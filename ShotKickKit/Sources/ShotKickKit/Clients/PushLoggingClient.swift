import ConcurrencyExtras
import Foundation
import Network

struct PushLoggingClient: Sendable {
  var start: @Sendable (Configuration, [LoggingClient]) async -> Void
  var state: @Sendable () -> any AsyncSequence<String, Never>
  var shotsLogged: @Sendable () -> any AsyncSequence<Int, Never>
}

extension PushLoggingClient {
  static func live(
    estimates: @Sendable @escaping () -> ShotEstimates
  ) -> PushLoggingClient {
    let server = SimpleInsecureListener()
    let shots = AsyncStream<Int>.makeStream()
    let monitor = LockIsolated(Task<Void, Never>?.none)

    return PushLoggingClient(
      start: { [monitor] config, loggers in
        monitor.withValue {
          $0?.cancel()
        }
        let newMonitor = Task {
          for await case let .success(shotData) in server.received {
            if Task.isCancelled { return }
            do {
              let shot = try JSONDecoder.decent().decode(ShotDTO.self, from: shotData)
              let estimate = estimates().estimates[shot.profile.title] ?? estimates().defaultEstimate
              for logger in loggers {
                try await logger.log(shot.profile.title, estimate)
              }
            } catch {
              fatalError(error.localizedDescription)
            }
          }
        }
        monitor.setValue(newMonitor)

        do {
          try await server.start(port: config.localListenerPort)
        } catch {
          fatalError(error.localizedDescription)
        }
      },
      state: {
        server.state.map(\.displayValue)
      },
      shotsLogged: {
        shots.stream
      }
    )
  }
}
