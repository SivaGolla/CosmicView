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
            // fetchMediaOfTheDay()
            
            Task {
                await fetchAsyncMediaOfTheDay()
            }
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
//        Task {
//            await fetchAsyncMediaOfTheDay()
//        }
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
    
    // Asynchronously fetches the Astronomy Picture of the Day (APOD) media for the selected date.
    private func fetchAsyncMediaOfTheDay() async {
        
        // Start the loading animation to indicate that the fetching process is ongoing.
        LoadingView.start()

        // Get the active request ID from the constants and use it to create a URL search parameter model for the service request.
        let requestId = Constants.activeRequestId
        let urlSearchParams = CosmicSnapshotRequestModel(id: requestId, date: selectedDate)

        // Create an instance of the AstroService to make the network request.
        let serviceRequest = AstroService()
        serviceRequest.urlSearchParams = urlSearchParams

        do {
            // Attempt to fetch the APOD media using the service. The `fetch` function returns a `Result` object.
            let result: Result<CosmicSnapshot, NetworkError> = try await serviceRequest.fetch()

            // Check if the result is successful. If so, set the fetched media item to the media viewer.
            if case .success(let mediaItem) = result {
                mediaViewer.mediaItem = mediaItem
            }

        } catch let error as NSError {
            // If an error occurs during the fetching process, print the error for debugging purposes,
            // stop the loading animation, and show an error prompt to the user.
            debugPrint(error.debugDescription)
            LoadingView.stop()
            showErrorPrompt()
        }

        // Make the date picker visible again after the fetch operation is completed.
        datePicker.isHidden = false
    }
    
    /// Displays an alert to the user when an error occurs during data fetching.
    private func showErrorPrompt() {
        let alert = UIAlertController(title: "Warning", message: "Failed to Download..", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
