import SwiftUI

public struct MacScenes: Scene {

  public init(state: Binding<AppState>) {
    _state = state
  }

  @Binding private var state: AppState

  public var body: some Scene {
    WindowGroup {
      TabView {
        Tab("Settings", systemImage: "gear") {
          SettingsScreen()
        }
        Tab("Profiles", systemImage: "cup.and.heat.waves.fill") {
          ShotEstimatesScreen()
        }
      }
      .frame(minWidth: 400, minHeight: 400)
      .environment(state)
    }
    .windowResizability(.contentSize)
  }
}
