extension AppState {
  @MainActor
  public static func live() -> AppState {
    let shortcuts = ShortcutClient.live()
    let estimates = ShotEstimates()
    return AppState.init(
      config: .defaults,
      decent: { config in .live(host: config.decentURL()) },
      estimates: { estimates },
      logging: PushLoggingClient.live(estimates: { estimates }),
      loggers: { [MacroFactorLoggingClient.live($0, shortcuts)] },
      shortcuts: shortcuts
    )
  }
}
