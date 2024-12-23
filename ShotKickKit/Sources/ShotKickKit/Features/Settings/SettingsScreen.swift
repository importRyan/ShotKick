import SwiftUI

struct SettingsScreen: View {
  @Environment(AppState.self) private var state

  var body: some View {
    Form {
      Section("Decent Tablet") {
        LabeledContent("IP", value: state.config.decentIP)
        LabeledContent("Port", value: state.config.decentPort, format: .number.grouping(.never))
      }
      Section("Local Shot Listener") {
        LabeledContent("Port", value: state.config.localListenerPort, format: .number.grouping(.never))
        LabeledContent("State", value: state.serverState)
      }
      Section("Logging") {
        HStack {
          LabeledContent("MacroFactor Shortcut", value: state.config.macroFactorShortcutName)
          Button("Install") {
            state.installMacroFactorShortcut()
          }
        }
      }
    }
    .formStyle(.grouped)
  }
}
