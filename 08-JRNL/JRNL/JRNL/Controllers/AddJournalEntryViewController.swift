//
//  AddJournalEntryViewController.swift
//  JRNL
//
//  Created by Jungman Bae on 3/26/25.
//

import UIKit
import CoreLocation

class AddJournalEntryViewController: UIViewController {

  @IBOutlet weak var getLocationSwitch: UISwitch!
  @IBOutlet weak var getLocationSwitchLabel: UILabel!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var bodyTextView: UITextView!
  @IBOutlet weak var photoImageView: UIImageView!

  var newJournalEntry: JournalEntry?
  let locationManager = CLLocationManager()
  var currentLocation: CLLocation?

  override func viewDidLoad() {
    super.viewDidLoad()
//    스토리보드 내에서 delegate를 설정해줬기 때문에 아래 코드는 필요없다.
//    titleTextField.delegate = self
//    bodyTextView.delegate = self
      
      // 위치 정보 사용을 위한 설정
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
  }

  @IBAction func getLocationSwitchValueChanged(_ sender: Any) {
    if getLocationSwitch.isOn {
      getLocationSwitchLabel.text = "Getting location..."
      locationManager.requestLocation()
    } else {
      getLocationSwitchLabel.text = "Get Location"
    }
  }
  

  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("prepare: \(String(describing: segue.identifier))")
    if let segueIndentifier = segue.identifier {
      if segueIndentifier == "save" {
        let title = titleTextField.text ?? ""
        let body = bodyTextView.text ?? ""
        let photo = photoImageView.image
        let rating = 3
        newJournalEntry = JournalEntry(rating: rating, title: title, body: body, photo: photo)
      }
    }
  }

  // MARK: - Methods
  func updateSaveButtonState() {
    let titleText = titleTextField.text ?? ""
    let bodyText = bodyTextView.text ?? ""
    saveButton.isEnabled = !titleText.isEmpty && !bodyText.isEmpty
  }

  // 위치 권한 거부 알림 다이얼로그 표시 메서드
  func showLocationPermissionDeniedAlert() {
    let alertController = UIAlertController(
      title: "위치 정보 권한 필요",
      message: "이 앱의 기능을 사용하기 위해서는 위치 정보 접근 권한이 필요합니다. 설정에서 위치 접근 권한을 허용해주세요.",
      preferredStyle: .alert
    )

    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

    let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
      self.openAppSettings()
    }

    alertController.addAction(cancelAction)
    alertController.addAction(settingsAction)

    present(alertController, animated: true, completion: nil)
  }

  // 앱 설정 페이지로 이동하는 메서드
  private func openAppSettings() {
    if let prefs = URL(string: "App-prefs:LOCATION/LOCATION_SERVICES/kr.co.codegrove.JRNL") {
      // 대체 URL 시도
      UIApplication.shared.open(prefs, options: [:], completionHandler: nil)
    } else if let prefs = URL(string: "prefs:root=Privacy&path=LOCATION") {
      // 또 다른 대체 URL 시도
      UIApplication.shared.open(prefs, options: [:], completionHandler: nil)
    } else {
      // 위 URL들이 모두 실패할 경우 기본 설정 앱으로 이동
      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
      }
    }
  }

}

// MARK: - UITextFieldDelegate
extension AddJournalEntryViewController: UITextFieldDelegate {
  // 텍스트 필드가 편집을 시작할 때 호출
  func textFieldDidBeginEditing(_ textField: UITextField) {
    saveButton.isEnabled = false
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print("textFieldShouldReturn")
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    updateSaveButtonState()
  }
}

// MARK: - UITextViewDelegate
extension AddJournalEntryViewController: UITextViewDelegate {
  // 텍스트 뷰가 편집을 시작할 때 호출
  func textViewDidBeginEditing(_ textView: UITextView) {
    saveButton.isEnabled = false
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    print("shouldChangeTextIn: \(text)")
    if text == "\n" {
      textView.resignFirstResponder()
    }
    return true
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    updateSaveButtonState()
  }
}

// MARK: - CLLocationManagerDelegate
extension AddJournalEntryViewController: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:
      print("authorizedWhenInUse")
    case .denied:
      // 위치 정보 사용이 거부된 경우
      showLocationPermissionDeniedAlert()
      print("denied")
    case .notDetermined:
      print("notDetermined")
    case .restricted:
      print("restricted")
    case .authorizedAlways:
      print("authorizedAlways")
    @unknown default:
      print("unknown")
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    currentLocation = location
    getLocationSwitchLabel.text = "Location: \(location.coordinate.latitude), \(location.coordinate.longitude)"
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error: \(error)")

  }
}
