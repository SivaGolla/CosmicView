//
//  MediaViewer.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import UIKit
import WebKit
import YouTubeiOSPlayerHelper
import AVKit

/// A view responsible for rendering different types of media, including images, YouTube videos, web videos, and native videos.
///
class MediaViewer: UIView {
    
    // MARK: - Enums
    
    /// Enum to represent different types of media rendering.
    enum MediaRenderType {
        case image
        case youtube
        case web
        case native
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webPlayerView: UIView!
    @IBOutlet weak var youTublePlayerView: YTPlayerView!
    
    // MARK: - Private Properties
    
    private let nibFileName = "MediaViewer"
    private var webPlayer: WKWebView!
    private var mediaRendererType: MediaRenderType = .image
    
    // MARK: - Public Properties
    
    /// The data model containing information about the mediaItem.
    ///
    var mediaItem: CosmicSnapshot? = nil {
        willSet {
            guard let mediaInstance = newValue else {
                return
            }
            
            imageTitle.text = mediaInstance.title
            descLabel.text = mediaInstance.explanation
            
            switch mediaInstance.mediaType {
            case .image:
                mediaRendererType = .image
                showCurrentPlayerAndHideOtherPlayers()
                AsyncMedia.loadImage(urlPath: mediaInstance.hdUrl ?? "", placeholder: Constants.placeholderImage) { [weak self] image in
                    
                    DispatchQueue.main.async {
                        LoadingView.stop()
                        self?.imageView.image = image
                    }
                }
                
            case .video:
                loadRemote(video: mediaInstance)
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Setup Methods
    
    func commonInit() {
        // Load the view from the XIB file and add it as a subview.
        
        let viewFromXib = Bundle.main.loadNibNamed("MediaViewer", owner: self, options: nil)?.first as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        imageView.layer.cornerRadius = 5
        youTublePlayerView.layer.cornerRadius = 5
        youTublePlayerView.delegate = self
        setupWebView()
    }
    
    func setupWebView() {
        // Configure and initialize the WKWebView for rendering web content.
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        webPlayer = WKWebView(frame: self.webPlayerView.bounds, configuration: webConfiguration)
        webPlayer.navigationDelegate = self
        webPlayer.accessibilityIdentifier = "webPlayer"
        webPlayer.backgroundColor = .clear
        webPlayer.isOpaque = false
        webPlayerView.addSubview(self.webPlayer)
        webPlayerView.layer.cornerRadius = 5
        
        // Set autoresizing mask for responsive resizing.
        webPlayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Media Loading Methods
    
    /// Renders the remote video based on the CosmicSnapshot data.
    /// - Parameter cosmicData: The data model containing information about the CosmicSnapshot.
    ///
    func loadRemote(video: CosmicSnapshot) {
        
        // Check if the URL is a valid YouTube URL.
        if video.url.isValidYouTubeUrlPath() {
            guard let videoId = video.url.youtubeID else {
                LoadingView.stop()
                return
            }
            mediaRendererType = .youtube
            showCurrentPlayerAndHideOtherPlayers()
            youTublePlayerView.load(withVideoId: videoId, playerVars: ["playsinline": "1"])
            
        } else {
            // Load the video from a web URL.
            
            AsyncMedia.loadVideo(urlPath: video.url) { htmlString in
                
                guard let videoPath = htmlString, !videoPath.isEmpty else {
                    LoadingView.stop()
                    return
                }
                
                self.mediaRendererType = .web
                self.showCurrentPlayerAndHideOtherPlayers()
                self.webPlayer.loadHTMLString(videoPath, baseURL: nil)
                self.webPlayerView.layoutIfNeeded()
            }
        }
    }
    
    /// Loads and plays a native video using AVPlayer.
    /// - Parameter videoUrlPath: The URL path of the video to play.
    ///
    func loadNativePlayer(videoUrlPath: String) {
        guard let videoUrl = URL(string: videoUrlPath) else {
            // Invalid URL, can't play video.
            return
        }
        
        youTublePlayerView.stopVideo()
        imageView.isHidden = true
        youTublePlayerView.isHidden = true
        
        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = youTublePlayerView.bounds
        self.layer.addSublayer(playerLayer)
        player.play()
    }
    
    // MARK: - Helper Methods
    
    /// Shows the current media player and hides others based on the media type.
    ///
    func showCurrentPlayerAndHideOtherPlayers() {
        switch mediaRendererType {
        case .image:
            webPlayerView.isHidden = true
            webPlayer.stopLoading()
            youTublePlayerView.stopVideo()
            youTublePlayerView.isHidden = true
            imageView.isHidden = false
            
        case .youtube:
            youTublePlayerView.stopVideo()
            imageView.isHidden = true
            webPlayerView.isHidden = true
            webPlayer.stopLoading()
            youTublePlayerView.isHidden = false
            
        case .web:
            self.youTublePlayerView.stopVideo()
            self.youTublePlayerView.isHidden = true
            self.imageView.isHidden = true
            self.webPlayer.stopLoading()
            self.webPlayerView.isHidden = false
            
        case .native:
            // Native player is not in use in this implementation.
            break
        }
    }
}

// MARK: - WKNavigationDelegate

extension MediaViewer: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Stop loading indicator once the web view finishes loading.

        LoadingView.stop()
    }
}

// MARK: - YTPlayerViewDelegate

extension MediaViewer: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        // Stop loading indicator once the YouTube player is ready.
        LoadingView.stop()
    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        
        // Return clear color for the YouTube player's background.
        return .clear
    }
}
