//
//  JournalEntryDetailViewController.swift
//  JRNL
//
//  Created by Jungman Bae on 3/27/25.
//

import UIKit
import MapKit

class JournalEntryDetailViewController: UITableViewController {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var ratingView: RatingView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var bodyTextView: UITextView!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var mapImageView: UIImageView!

  var selectedJournalEntry: JournalEntry?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  func setupUI() {
    guard let selectedJournalEntry = selectedJournalEntry else {
      return
    }
    dateLabel.text = selectedJournalEntry.title
    ratingView.rating = selectedJournalEntry.rating
    titleLabel.text = selectedJournalEntry.entryTitle
    bodyTextView.text = selectedJournalEntry.entryBody
    if let photoData = selectedJournalEntry.photoData {
      photoImageView.image = UIImage(data: photoData)
    }
    getMapSnapshot()
  }

  func getMapSnapshot() {
    guard let selectedJournalEntry = selectedJournalEntry,
          let latitude = selectedJournalEntry.latitude,
          let longitude = selectedJournalEntry.longitude else {
      return
    }
    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

    let mapSnapshotOptions = MKMapSnapshotter.Options()

    let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
    mapSnapshotOptions.region = region
    mapSnapshotOptions.size = mapImageView.frame.size
    mapSnapshotOptions.scale = UIScreen.main.scale

    let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
    snapShotter.start { (snapshot, error) in
      guard let snapshot = snapshot else {
        self.mapImageView.image = UIImage(systemName: "map")
        return
      }
      let image = snapshot.image
      self.mapImageView.image = image
    }
  }
}

