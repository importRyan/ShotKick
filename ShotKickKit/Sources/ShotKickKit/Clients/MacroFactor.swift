import Foundation
import Nutrition

struct MacroFactorLoggingClient: LoggingClient {
  var log: @Sendable (String, ShotEstimate) async throws -> Void
}

extension MacroFactorLoggingClient {
  static func live(
    _ config: Configuration,
    _ shortcuts: ShortcutClient
  ) -> MacroFactorLoggingClient {
    MacroFactorLoggingClient(
      log: { title, estimate in
        let food = MacroFactorFood(
          source: "decent",
          icon: estimate.icon.macroFactorIcon,
          name: title,
          nutrients: [
            .caffeine: estimate.caffeineMg,
            .water: estimate.waterMl
          ],
          serving: .one,
          llmPrompt: nil,
          barcode: nil,
          brand: nil,
          beverage: .beverage,
          notes: nil,
          recipe: nil
        )
        let data = try JSONEncoder.shortcuts().encode(food)
        guard let json = String(data: data, encoding: .utf8) else {
          fatalError()
        }
        _ = try shortcuts.run(config.macroFactorShortcutName, json)
      }
    )
  }
}

private extension Icon {
  var macroFactorIcon: Nutrition.Icon {
    switch self {
    case .brew: .coffee
    case .cappuccino: .coffeeCappuccino
    case .espresso: .coffeeEspresso
    case .iced: .coffeeIceWhip
    }
  }
}
