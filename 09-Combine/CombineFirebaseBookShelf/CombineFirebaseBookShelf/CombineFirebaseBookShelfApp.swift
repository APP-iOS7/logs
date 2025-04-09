//
//  CombineFirebaseBookShelfApp.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    // 에뮬레이터 설정
    Auth.auth().useEmulator(withHost: "localhost", port: 9099)
    Firestore.firestore().useEmulator(withHost: "localhost", port: 8080)
    // Firestore Settings
    let settings = Firestore.firestore().settings
    settings.cacheSettings = MemoryCacheSettings(garbageCollectorSettings: MemoryLRUGCSettings())
    settings.isSSLEnabled = false
    Firestore.firestore().settings = settings

    return true
  }
}

@main
struct CombineFirebaseBookShelfApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
