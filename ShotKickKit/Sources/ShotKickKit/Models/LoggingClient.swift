protocol LoggingClient: Sendable {
  var log: @Sendable (String, ShotEstimate) async throws -> Void { get }
}
