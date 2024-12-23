import Foundation

@MainActor
@Observable
public final class AppState {
  var serverState = ""
  var shotsLogged = 0
  var config: Configuration

  private(set) var decent: DecentClient
  private let decentBuilder: (Configuration) -> DecentClient
  let estimates: @Sendable () -> ShotEstimates
  private let loggers: @Sendable (Configuration) -> [LoggingClient]
  private let pushLogging: PushLoggingClient
  private let shortcuts: ShortcutClient
  private var updates: Set<Task<Void, Never>> = []

  init(
    config: Configuration,
    decent: @Sendable @escaping (Configuration) -> DecentClient,
    estimates: @Sendable @escaping () -> ShotEstimates,
    logging: PushLoggingClient,
    loggers: @Sendable @escaping (Configuration) -> [LoggingClient],
    shortcuts: ShortcutClient
  ) {
    self.config = config
    self.decent = decent(config)
    self.decentBuilder = decent
    self.estimates = estimates
    self.loggers = loggers
    self.pushLogging = logging
    self.shortcuts = shortcuts
  }
}

extension AppState {
  public func start() async {
    watchServerState()
    decent = decentBuilder(config)
    await pushLogging.start(config, loggers(config))
  }

  func installMacroFactorShortcut() {
    shortcuts.installMacroFactorShortcut()
  }
}

private extension AppState {
  func watchServerState() {
    updates.forEach { $0.cancel() }
    updates.removeAll()

    updates.insert(
      Task { [weak self] in
        guard let self else { return }
        for await state in pushLogging.state() {
          serverState = state
        }
      }
    )

    updates.insert(
      Task { [weak self] in
        guard let self else { return }
        for await count in pushLogging.shotsLogged() {
          shotsLogged = count
        }
      }
    )
  }
}
