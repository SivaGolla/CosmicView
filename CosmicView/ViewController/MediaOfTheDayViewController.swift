//
//  PictureOfTheDayViewController.swift
//  CosmicView
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import UIKit

/// A view controller responsible for displaying the Astronomy Media of the Day (Image or Video) and handling user interactions.
class MediaOfTheDayViewController: UIViewController {

    /// Outlet for the UIDatePicker used to select a date.
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /// Outlet for the UIScrollView responsible for containing media viewer.
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    /// Outlet for the custom view responsible for rendering media.
    @IBOutlet weak var mediaViewer: MediaViewer!
    
    /// The date selected by the user, defaulting to one day prior to the current date.
    /// This property triggers a media download when its value changes.
    ///
    var selectedDate: Date = Date() {
        didSet {
            print(selectedDate)
            fetchMediaOfTheDay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the accessibility identifiers for UI elements for better accessibility support and testing.
        view.accessibilityIdentifier = "homeView"
        datePicker.accessibilityIdentifier = "astroPixDatePicker"
        
        // Configure the date picker and initiate the download of the media for a date.
        populateDatePicker()
        fetchMediaOfTheDay()
    }
    
    /// Handles date selection from the date picker and updates the `selectedDate` property.
    @IBAction func handleDateSelection() {
        
        dismiss(animated: false) { [weak self] in
            self?.selectedDate = self?.datePicker.date ?? Date()
        }
    }

    /// Configures the appearance and behavior of the date picker.
    private func populateDatePicker() {
        datePicker.date = selectedDate
        datePicker.maximumDate = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
    }
}

extension MediaOfTheDayViewController {
    
    /// Downloads the media based on the selected date and updates the media viewer.
    private func fetchMediaOfTheDay() {
        LoadingView.start()  // Show a loading indicator to inform the user that data is being fetched.
        
        // Create the request model with the current request ID and selected date.
        let requestId = Constants.activeRequestId
        let urlSearchParams = CosmicSnapshotRequestModel(id: requestId, date: selectedDate)
        
        // Initialize the service request with the specified parameters.
        let serviceRequest = AstroService()
        serviceRequest.urlSearchParams = urlSearchParams
        
        // Fetch the media content using the service request.
        serviceRequest.fetch { [weak self] (result: Result<CosmicSnapshot, NetworkError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                LoadingView.stop()
                // Show an error prompt to the user.
                self?.showErrorPrompt()
                
            case .success(let mediaItem):
                // Update the media viewer with the fetched Media Item.
                
                self?.mediaViewer.mediaItem = mediaItem
            }
            self?.datePicker.isHidden = false
        }
    }
    
    /// Displays an alert to the user when an error occurs during data fetching.
    private func showErrorPrompt() {
        let alert = UIAlertController(title: "Warning", message: "Failed to Download..", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
