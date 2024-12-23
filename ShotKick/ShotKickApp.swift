import ShotKickKit
import SwiftUI

@main
struct ShotKickApp: App {

  init() {
    let state = AppState.live()
    _state = .init(wrappedValue: state)
    Task { await state.start() }
  }

  @State var state: AppState

  var body: some Scene {
    MacScenes(state: $state)
  }
}
