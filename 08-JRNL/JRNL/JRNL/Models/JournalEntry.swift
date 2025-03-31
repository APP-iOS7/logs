//
//  JournalEntry.swift
//  JRNL
//
//  Created by Jungman Bae on 3/26/25.
//
import UIKit
import MapKit
import SwiftData

@Model
class JournalEntry {
  var id: UUID
  var date: Date
  var rating: Int
  var entryTitle: String
  var entryBody: String
  @Attribute(.externalStorage) var photoData: Data?
  var latitude: Double?
  var longitude: Double?

  init?(rating: Int, title: String, body: String, photo: UIImage? = nil, latitude: Double? = nil, longitude: Double? = nil) {
    if title.isEmpty || body.isEmpty || rating < 0 || rating > 5 {
      return nil
    }
    self.id = UUID()
    self.date = Date()
    self.rating = rating
    self.entryTitle = title
    self.entryBody = body
    self.photoData = photo?.jpegData(compressionQuality: 1.0)
    self.latitude = latitude
    self.longitude = longitude
  }

  @Transient
  var title: String? {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }

}
