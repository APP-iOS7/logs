//
//  CreatePostView.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI
import PhotosUI // PhotosPicker 사용

struct CreatePostView: View {
  let boardId: String
  @StateObject private var viewModel = CreatePostViewModel() // 별도 ViewModel 사용 권장

  @State private var postTitle: String = ""
  @State private var postContent: String = ""
  @State private var selectedItem: PhotosPickerItem? = nil // PhotosPicker 선택 항목
  @State private var selectedImageData: Data? = nil // 로드된 이미지 데이터
  @State private var selectedImagePreview: Image? // 미리보기용 SwiftUI Image

  @Environment(\.dismiss) var dismiss // 뷰 닫기

  var body: some View {
    NavigationView {
      Form {
        TextField("Title", text: $postTitle)
        TextEditor(text: $postContent)
          .frame(height: 200) // 적절한 높이 지정

        PhotosPicker(selection: $selectedItem, matching:.images) { // [83, 85, 87]
          HStack {
            Image(systemName: "photo")
            Text("Select Image")
          }
        }

        if let selectedImagePreview {
          selectedImagePreview
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 200)
        }
      }
      .navigationTitle("New Post")
      .navigationBarItems(leading: Button("Cancel") { dismiss() },
                          trailing: Button("Post") {
        Task {
          await viewModel.createPost(
            boardId: boardId,
            title: postTitle,
            content: postContent,
            imageData: selectedImageData
          )
          // 성공/실패 처리 후 dismiss() 호출
          if viewModel.errorMessage == nil {
            dismiss()
          }
        }
      }
        .disabled(postTitle.isEmpty || postContent.isEmpty || viewModel.isUploading) // 기본 유효성 검사 및 업로드 중 비활성화
      )
      .onChange(of: selectedItem) { newItem, _ in // 선택 변경 시 이미지 데이터 로드
        Task {
          if let data = try? await newItem?.loadTransferable(type: Data.self) { //
            selectedImageData = data
            if let uiImage = UIImage(data: data) {
              selectedImagePreview = Image(uiImage: uiImage)
            }
          } else {
            selectedImageData = nil
            selectedImagePreview = nil
          }
        }
      }
      .overlay { // 로딩 및 오류 표시
        if viewModel.isUploading { ProgressView("Uploading...") }
        if let error = viewModel.errorMessage { Text("Error: (error)").foregroundColor(.red) }
      }
    }
  }
}
