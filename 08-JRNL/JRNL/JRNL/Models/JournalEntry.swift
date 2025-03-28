//
//  JournalEntry.swift
//  JRNL
//
//  Created by Jungman Bae on 3/26/25.
//
import UIKit
import MapKit

class JournalEntry: NSObject, MKAnnotation, Codable {
  var id: UUID = UUID()
  let dateString: String
  let rating: Int
  let entryTitle: String
  let entryBody: String
  let photoData: Data?
  let latitude: Double?
  let longitude: Double?

  init?(rating: Int, title: String, body: String, photo: UIImage? = nil, latitude: Double? = nil, longitude: Double? = nil) {
    if title.isEmpty || body.isEmpty || rating < 0 || rating > 5 {
      return nil
    }
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    self.dateString = formatter.string(from: Date())
    self.rating = rating
    self.entryTitle = title
    self.entryBody = body
    self.photoData = photo?.jpegData(compressionQuality: 1.0)
    self.latitude = latitude
    self.longitude = longitude
  }

  // MARK: - MKAnnotation
  var title: String? {
    dateString
  }

  var subtitle: String? {
    entryTitle
  }

  var coordinate: CLLocationCoordinate2D {
    guard let latitude = latitude, let longitude = longitude else {
      return CLLocationCoordinate2D()
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
