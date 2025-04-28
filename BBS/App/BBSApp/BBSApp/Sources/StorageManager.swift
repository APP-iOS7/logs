//
//  StorageManager.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import FirebaseStorage
import Foundation
import UIKit
import FirebaseAuth

class StorageManager {
  static let shared = StorageManager()
  private let storage = Storage.storage()

  private init() {}

  func uploadPostImage(imageData: Data, postId: String) async throws -> URL {
    // 현재 사용자 인증 상태 확인
    guard Auth.auth().currentUser != nil,
          let userId = Auth.auth().currentUser?.uid else {
      throw NSError(domain: "AppError", code: -2, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    guard let image = UIImage(data: imageData),
          let compressedData = image.jpegData(compressionQuality: 0.8) else { // [5]
      throw NSError(domain: "AppError", code: -1, userInfo: nil)
    }

    let fileName = "\(UUID().uuidString).jpg"
    let storageRef = storage.reference().child("posts/\(postId)/\(fileName)") // [90, 91]

    // 메타데이터 설정
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    metadata.customMetadata = ["uploadedBy": userId] // 사용자 ID 저장 (비정규화)

    // putDataAsync 사용 (권장) [103]
    let _ = try await storageRef.putDataAsync(compressedData, metadata: metadata)
    print("Image uploaded successfully")

    // 다운로드 URL 가져오기 [90, 91, 97, 98]
    let downloadURL = try await storageRef.downloadURL()
    print("Download URL: \(downloadURL.absoluteString)")
    return downloadURL
  }
}
