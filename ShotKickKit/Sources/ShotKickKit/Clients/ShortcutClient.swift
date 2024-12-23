import SwiftUI

struct ShortcutClient: Sendable {
  var run: @Sendable (_ shortcut: String, _ text: String) throws -> Bool
  var installMacroFactorShortcut: @Sendable () -> Void
}

extension ShortcutClient {
  static func live() -> Self {
    ShortcutClient(
      run: { shortcut, text in
        var components = URLComponents(string: "shortcuts://run-shortcut")!
        components.queryItems = [
          URLQueryItem(name: "name", value: shortcut),
          URLQueryItem(name: "input", value: "text"),
          URLQueryItem(name: "text", value: text),
        ]
        guard let shortcutURL = components.url else { throw URLError(.badURL) }
        return open(shortcutURL)
      },
      installMacroFactorShortcut: {
        let url = URL(string: "https://www.icloud.com/shortcuts/eb6cacb4dc50402aaead5439ebc6061a")!
        open(url)
      }
    )
  }
}

@discardableResult
private func open(_ url: URL) -> Bool {
#if os(macOS)
return NSWorkspace.shared.open(url)
#endif
}
