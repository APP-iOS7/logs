//
//  JournalEntryMKAnnotation.swift
//  JRNL
//
//  Created by Jungman Bae on 3/31/25.
//

import MapKit

class JournalEntryMKAnnotation: NSObject, MKAnnotation {
  let journalEntry: JournalEntry

  init(journalEntry: JournalEntry) {
    self.journalEntry = journalEntry
  }

  var title: String? {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: journalEntry.date)
  }

  var subtitle: String? {
    journalEntry.entryTitle
  }

  var coordinate: CLLocationCoordinate2D {
    guard let latitude = journalEntry.latitude, let longitude = journalEntry.longitude else {
      return CLLocationCoordinate2D()
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
