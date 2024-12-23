import SwiftUI

extension DecentRestApi {
  enum GET {
    case status
    case statusDetails
    case shotList
    case shot(id: String)
    case profileList
    case profile(id: String)

    var path: String {
      switch self {
      case .status: "status"
      case .statusDetails: "status/details"
      case .shotList: "v2/shots"
      case .shot(let id): "v2/shot/\(id)"
      case .profileList: "profile"
      case .profile(let id): "profile/\(id)"
      }
    }
  }

  enum POST: String {
    case status
    case profile
  }

  enum PUT {
    case selectProfile(id: String)

    var path: String {
      switch self {
      case .selectProfile(let id): "profile/\(id)"
      }
    }
  }
}

struct DecentRestApi {

  private let url: URL

  init(host: URL) {
    self.url = host.appending(path: "api")
  }

  func endpoint(get: GET) -> URLRequest {
    URLRequest(url: url.appending(path: get.path))
  }

  func endpoint(post: POST) -> URLRequest {
    URLRequest(url: url.appending(path: post.rawValue))
  }

  func endpoint(put: PUT) -> URLRequest {
    URLRequest(url: url.appending(path: put.path))
  }
}
