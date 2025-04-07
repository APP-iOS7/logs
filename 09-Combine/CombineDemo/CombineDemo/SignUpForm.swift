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
  }
}

#Preview {
  SignUpForm()
}
