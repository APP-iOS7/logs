//
//  LoginView.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI

struct LoginView: View {
  @EnvironmentObject var authViewModel: AuthViewModel

  @State private var email = ""
  @State private var password = ""
  @State private var emailError: String? = nil

  var isFormValid: Bool {
    !email.isEmpty && !password.isEmpty && emailError == nil // Add more checks as needed
  }

  var body: some View {
    VStack {
      TextField("Email", text: $email)
        .keyboardType(.emailAddress)
        .autocapitalization(.none)
        .onChange(of: email) { newValue in
          // Basic email format check (replace with robust validation)
          if !newValue.contains("@") && !newValue.isEmpty {
            emailError = "유효한 이메일 주소를 입력하세요."
          } else {
            emailError = nil
          }
        }

      if let emailError = emailError {
        Text(emailError)
          .foregroundColor(.red)
          .font(.caption)
      }

      SecureField("Password", text: $password)

      Button("로그인") {
        Task {
          await authViewModel.signIn(withEmail: email, password: password)
        }
      }
      .disabled(!isFormValid) // 버튼 비활성화 조건
    }
    .padding()
  }
}
#Preview {
  LoginView()
}
