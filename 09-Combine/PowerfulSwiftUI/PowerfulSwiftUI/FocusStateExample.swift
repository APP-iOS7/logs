//
//  FocusStateExample.swift
//  PowerfulSwiftUI
//
//  Created by Jungman Bae on 4/3/25.
//

import SwiftUI

struct FocusStateExample: View {
  enum Field: Hashable {
    case username
    case password
    // 추가적인 필드를 정의할 수 있습니다. (예시)
    case field3
    case field4
  }

  @State private var username = ""
  @State private var password = ""

  // 사용자의 포커스 상태를 관리하는 데 사용됩니다.
  @FocusState private var focusedField: Field?

  var body: some View {
    VStack {
      TextField("Username", text: $username)
      // 포커스 상태를 관리하는 데 사용됩니다.
        .focused($focusedField, equals: .username)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .submitLabel(.next)
        .onSubmit {
          focusedField = .password
        }

      SecureField("Password", text: $password)
        .focused($focusedField, equals: .password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .submitLabel(.done)
        .onSubmit {
          focusedField = nil
        }

      VStack(spacing: 20) {
        Button("Focus Username") {
          focusedField = .username
        }
        .buttonStyle(BorderedProminentButtonStyle())

        Button("Focus Password") {
          focusedField = .password
        }
        .buttonStyle(BorderedProminentButtonStyle())

        Button("Dismiss Keyboard") {
          focusedField = nil
        }
        .buttonStyle(BorderedProminentButtonStyle())
      }
      .padding()
    }
    .padding()
  }
}

#Preview {
  FocusStateExample()
}
