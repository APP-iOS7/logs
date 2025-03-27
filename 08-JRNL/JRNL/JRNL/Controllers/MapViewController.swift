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

  override func viewDidLoad() {
    super.viewDidLoad()

    // 위치 정보 사용을 위한 설정
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    self.navigationItem.title = "Loading..."
    locationManager.requestLocation()
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
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }
}

extension MapViewController: MKMapViewDelegate {

}
