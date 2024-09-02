//
//  LoadingView.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import Foundation
import UIKit

/// A class responsible for managing a loading spinner (activity indicator) that can be displayed over the application's main window.
open class LoadingView {
    
    /// The shared instance of `UIActivityIndicatorView` used for showing the loading spinner.
    internal static var spinner: UIActivityIndicatorView?
    
    /// The style of the loading spinner. Default is `.large`.
    public static var style: UIActivityIndicatorView.Style = .large
    
    /// The color of the loading spinner. Default is gray.
    public static var baseColor = UIColor.gray
    
    /// Displays the loading spinner on the main window.
    ///
    /// - Parameters:
    ///   - style: The style of the activity indicator (e.g., `.large` or `.medium`). Defaults to the class's `style` property.
    ///   - baseColor: The color of the activity indicator. Defaults to the class's `baseColor` property.
    ///   
    public static func start(style: UIActivityIndicatorView.Style = style, baseColor: UIColor = baseColor) {
        // Check if the spinner is already initialized and if not, create and configure it.
        if spinner == nil, let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            // Get the bounds of the screen to set the spinner's frame.
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            // Set the background color with a semi-transparent overlay.
            spinner?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            spinner?.style = style
            spinner?.color = baseColor
            // Add the spinner to the key window.
            window.addSubview(spinner ?? UIActivityIndicatorView())
            // Start animating the spinner.
            spinner!.startAnimating()
        }
    }
    
    /// Hides the loading spinner from the main window.
    public static func stop() {
        // Check if the spinner is initialized and remove it if it is.
        if spinner != nil {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
