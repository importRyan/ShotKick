import Foundation

struct Configuration: Sendable {
  var activeLoggers: Set<LoggingClients> = [.macroFactor]
  var localListenerPort: UInt16
  var decentIP: String
  var decentPort: Int
  var macroFactorShortcutName: String
}

extension Configuration {
  static let defaults = Configuration(
    localListenerPort: 80,
    decentIP: "192.168.18.36",
    decentPort: 8080,
    macroFactorShortcutName: "Silently Log MacroFactor JSON"
  )

  func decentURL() -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = decentIP
    urlComponents.port = decentPort
    return urlComponents.url!
  }
}
