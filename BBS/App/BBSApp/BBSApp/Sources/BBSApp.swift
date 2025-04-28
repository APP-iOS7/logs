import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    // Firestore Emulators
    let settings = Firestore.firestore().settings
    settings.host = "localhost:8080"
    settings.cacheSettings = MemoryCacheSettings()
    settings.isSSLEnabled = false

    // Auth
    Auth.auth().useEmulator(withHost: "localhost", port: 9099)

    // Storage
    Storage.storage().useEmulator(withHost: "localhost", port: 9199)

    return true
  }
}


@main
struct BBSApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
