import Foundation

extension Data {
  func pretty(encoding: String.Encoding = .utf8) -> String {
    if let object = try? JSONSerialization.jsonObject(with: self, options: []),
       let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]) {
      return String(data: data, encoding: encoding) ?? ""
    }
    return String(data: self, encoding: encoding) ?? ""
  }
}
