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
    NavigationStack {
      VStack {
        Spacer()
        TextField("Email", text: $email)
          .textFieldStyle(.roundedBorder)
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
          .autocorrectionDisabled()
          .onChange(of: email) { _,newValue in
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
          .textFieldStyle(.roundedBorder)
          .autocapitalization(.none)

        Button("로그인") {
          Task {
            await authViewModel.signIn(withEmail: email, password: password)
          }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
        .disabled(!isFormValid) // 버튼 비활성화 조건

        Button("회원가입") {
          Task {
            await authViewModel.signUp(withEmail: email, password: password, displayName: "")
          }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.bordered)
        .disabled(!isFormValid) // 버튼 비활성화 조건

        Spacer()
      }
      .padding()
      .navigationTitle("로그인 ")
      .background(Color(.systemGroupedBackground))
    }
  }
}
#Preview {
  LoginView()
}
