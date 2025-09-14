import ComposableArchitecture
import SwiftUI

@main
struct CountingNullsApp: App {
  init() {
    prepareDependencies {
      $0.defaultDatabase = try! appDatabase()
    }
  }
  
  var body: some Scene {
    WindowGroup {
      CountingNullsView(store: Store(initialState: CountingNullsFeature.State()) {
        CountingNullsFeature()
      })
    }
  }
}
