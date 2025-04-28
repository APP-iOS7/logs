//
//  StorageManager.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import FirebaseStorage
import Foundation
import SwiftUICore

class StorageManager {
  static let shared = StorageManager()
  private let storage = Storage.storage()

  private init() {}

  func uploadPostImage(imageData: Data, postId: String) async throws -> URL {
    // 이미지 압축 (선택적)
    // guard let image = UIImage(data: imageData),
    //       let compressedData = image.jpegData(compressionQuality: 0.8) else { // [5]
    //     throw NSError(domain: "AppError", code: -1, userInfo:)
    // }
    let compressedData = imageData // 압축 없이 원본 사용 예시

    let fileName = "\(UUID().uuidString).jpg"
    let storageRef = storage.reference().child("posts/\(postId)/\(fileName)") // [90, 91]

    // putDataAsync 사용 (권장) [103]
    let _ = try await storageRef.putDataAsync(compressedData)
    print("Image uploaded successfully")

    // 다운로드 URL 가져오기 [90, 91, 97, 98]
    let downloadURL = try await storageRef.downloadURL()
    print("Download URL: \(downloadURL.absoluteString)")
    return downloadURL
  }
}
