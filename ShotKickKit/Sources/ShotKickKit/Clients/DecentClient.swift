import Foundation

struct DecentClient {
  var getProfile: @Sendable (String) async throws -> Profile
  var getProfiles: @Sendable () async throws -> ProfileList
  var getShot: @Sendable (String) async throws -> ShotDTO
  var getShotList: @Sendable () async throws -> ShotListDTO
  var getStatus: @Sendable () async throws -> StatusDetailsDTO
}

extension DecentClient {
  static func live(host: URL) -> DecentClient {
    let api = DecentRestApi(host: host)
    return DecentClient(
      getProfile: { file in
        try await execute(api.endpoint(get: .profile(id: file)))
      },
      getProfiles: {
        try await execute(api.endpoint(get: .profileList))
      },
      getShot: { file in
        try await execute(api.endpoint(get: .shot(id: file)))
      },
      getShotList: {
        try await execute(api.endpoint(get: .shotList))
      },
      getStatus: {
        try await execute(api.endpoint(get: .statusDetails))
      }
    )
  }
}

private func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
  print(request.url!)
  let (data, response) = try await URLSession.shared.data(for: request)
  guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode)
  else { throw URLError(.badServerResponse) }
#if DEBUG
  print(data.pretty())
#endif
  return try JSONDecoder.decent().decode(T.self, from: data)
}
