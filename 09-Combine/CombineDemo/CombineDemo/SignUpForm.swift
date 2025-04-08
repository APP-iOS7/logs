//
//  SignUpForm.swift
//  CombineDemo
//
//  Created by Jungman Bae on 4/7/25.
//

import SwiftUI

struct SignUpForm: View {
  @StateObject private var viewModel = SignUpFormViewModel()

  var body: some View {
    Form {
      // 사용자 이름 입력 필드
      Section {
        TextField("사용자 이름", text: $viewModel.username)
      } footer: {
        Text(viewModel.usernameMessage)
          .foregroundColor(.red)
      }
      // 비밀번호 입력 필드
      Section {
        SecureField("비밀번호", text: $viewModel.password)
        SecureField("비밀번호 확인", text: $viewModel.passwordConfirmation)
      } footer: {
        Text(viewModel.passwordMessage)
          .foregroundColor(.red)
      }

      // Submit 버튼
      Section {
        Button("Sign up") {
          print("Sign up as \(viewModel.username)")
        }
        .disabled(!viewModel.isValid)
      }
    }
    // 업데이트 대화 상자 표시
    .alert("Please update", isPresented: $viewModel.showUpdateDialog, actions: {
      Button("Upgrade") {
        print("버전 업데이트 버튼 클릭")
      }
      Button("Not now", role: .cancel) { }
    }, message: {
      Text("업데이트가 필요합니다.")
    })
  }
}

#Preview {
  SignUpForm()
}
