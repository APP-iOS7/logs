//
//  DataManager.swift
//  TabDemo
//
//  Created by Jungman Bae on 3/19/25.
//

import UIKit

class DataManager {
  static let shared = DataManager() // 싱글톤 인스턴스
  private init() {} // 외부에서 초기화 방지

  // 데이터 저장을 위한 속성
  var data: String = ""

  // 알림을 통한 데이터 변경 알림
  static let dataChangedNotification = Notification.Name("DataChangedNotification")

  func updateData(_ newData: String) {
    data = newData

    // 알림 발송
    NotificationCenter.default.post(name: DataManager.dataChangedNotification, object: nil)
  }
}
