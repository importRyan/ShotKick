import Foundation

extension JSONDecoder {
  static func decent() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}

extension JSONEncoder {
  static func shortcuts() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [ .sortedKeys]
    return encoder
  }
}
