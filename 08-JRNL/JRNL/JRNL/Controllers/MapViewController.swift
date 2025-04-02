//
//  MapViewController.swift
//  JRNL
//
//  Created by Jungman Bae on 3/27/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!

  let locationManager = CLLocationManager()
  var selectedJournalEntry: JournalEntry?

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self

    // 위치 정보 사용을 위한 설정
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    self.navigationItem.title = "Loading..."
    locationManager.requestLocation()
    SharedData.shared.fetchJournalEntries()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if let segueIndentifier = segue.identifier {
      if segueIndentifier == "showMapDetail" {
        guard let entryDetailViewController = segue.destination as? JournalEntryDetailViewController else {
          fatalError("Unexpected destination: \(segue.destination)")
        }
        entryDetailViewController.selectedJournalEntry = selectedJournalEntry
      }
    }
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let coordinate = location.coordinate
      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      let region = MKCoordinateRegion(center: coordinate, span: span)
      mapView.setRegion(region, animated: true)
      self.navigationItem.title = "Map"
      let journalEntries = SharedData.shared.getAllJournalEntries()
      for entry in journalEntries {
        let annotation = JournalEntryMKAnnotation(journalEntry: entry)
        mapView.addAnnotation(annotation)
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }
}

extension MapViewController: MKMapViewDelegate {
  // 지도에 핀을 표시할 때 호출
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? JournalEntryMKAnnotation else {
      return nil
    }

    let identifier = "marker"
    var view: MKMarkerAnnotationView

    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    print("calloutAccessoryControlTapped")
    guard let annotation = mapView.selectedAnnotations.first as? JournalEntryMKAnnotation else {
      return
    }
    selectedJournalEntry = annotation.journalEntry
    performSegue(withIdentifier: "showMapDetail", sender: self)
  }
}
