//
//  AuthViewModel.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: UserProfile?
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var isAdmin = false // 역할 확인 결과 저장

  private var db = Firestore.firestore()

  init() {
    // 앱 시작 시 현재 로그인된 사용자 확인
    self.userSession = Auth.auth().currentUser
    Task {
      await fetchUser()
      await checkAdminRole() // 역할 확인
    }
  }

  func signIn(withEmail email: String, password: String) async {
    isLoading = true
    errorMessage = nil
    do {
      let result = try await Auth.auth().signIn(withEmail: email, password: password) // [22, 45, 46]
      self.userSession = result.user
      await fetchUser()
      await checkAdminRole()
      print("Successfully logged in as user: \(result.user.uid)")
    } catch {
      print("Failed to login user: \(error)")
      errorMessage = error.localizedDescription // [47, 46]
    }
    isLoading = false
  }

  func signUp(withEmail email: String, password: String, displayName: String) async {
    isLoading = true
    errorMessage = nil
    do {
      let result = try await Auth.auth().createUser(withEmail: email, password: password) // [45, 46]
      self.userSession = result.user
      // Firestore에 사용자 프로필 생성
      let newUserProfile = UserProfile(id: result.user.uid, displayName: displayName, email: email)
      try await createUserProfile(userProfile: newUserProfile) // [45, 48]
      self.currentUser = newUserProfile
      await checkAdminRole() // 새 사용자는 기본적으로 admin이 아님
      print("Successfully registered user: \(result.user.uid)")
      // 필요시 관리자 역할 할당 로직 호출 (예: 특정 이메일인 경우)
      // if email == "admin@example.com" { assignAdminRole(userId: result.user.uid) }
    } catch let error as NSError {
      print("Failed to register user: \(error)")
      // 특정 에러 코드 처리 (예: 이메일 중복) [46, 49]
      if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
        errorMessage = "이미 사용 중인 이메일입니다."
      } else {
        errorMessage = error.localizedDescription
      }
    } catch {
      print("Failed to register user: \(error)")
      errorMessage = error.localizedDescription
    }
    isLoading = false
  }

  func signOut() {
    do {
      try Auth.auth().signOut()
      self.userSession = nil
      self.currentUser = nil
      self.isAdmin = false
      print("Successfully signed out")
    } catch {
      print("Error signing out: \(error)")
      errorMessage = error.localizedDescription
    }
  }

  func fetchUser() async {
    guard let uid = userSession?.uid else { return }
    let userRef = db.collection("users").document(uid)
    do {
      self.currentUser = try await userRef.getDocument(as: UserProfile.self) // [22, 35, 48]
      print("User profile fetched: \(currentUser?.displayName ?? "N/A")")
    } catch {
      print("Error fetching user profile: \(error)")
      // 사용자가 로그인했지만 프로필이 없을 수 있음 (예: 가입 직후 오류)
      // 필요시 프로필 재생성 로직 추가
    }
  }

  // Firestore에 사용자 프로필 문서 생성
  private func createUserProfile(userProfile: UserProfile) async throws {
    guard let userId = userProfile.id else { throw NSError(domain: "AppError", code: -1, userInfo: nil) }
    let userRef = db.collection("users").document(userId)
    try userRef.setData(from: userProfile) // [6, 35]
    print("User profile created in Firestore for \(userId)")
  }

  // 역할 확인 (Custom Claims 사용 예시)
  func checkAdminRole() async {
    guard let user = userSession else {
      self.isAdmin = false
      return
    }
    do {
      let tokenResult = try await user.getIDTokenResult(forcingRefresh: true) // [50, 51, 52]
      self.isAdmin = tokenResult.claims["admin"] as? Bool ?? false
      print("Admin status checked: \(self.isAdmin)")
    } catch {
      print("Error getting ID token result: \(error)")
      self.isAdmin = false // 에러 발생 시 false로 처리
    }
  }

  // 관리자 역할 할당 함수 호출 (예시 - 실제 구현은 Cloud Function에서)
  // func assignAdminRole(userId: String) {... }
}
