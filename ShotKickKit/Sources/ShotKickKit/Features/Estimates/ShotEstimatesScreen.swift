import SwiftUI

struct ShotEstimatesScreen: View {
  @Environment(AppState.self) private var state

  @State var profiles = [ShotProfile]()

  var body: some View {
    Table(profiles) {
      TableColumn("Profile", value: \.name)
      TableColumn("Caffeine (mg)") { profile in
        Text(profile.estimate.caffeineMg, format: .number.precision(.fractionLength(0...1)))
      }
      TableColumn("Water (mL)") { profile in
        Text(profile.estimate.waterMl, format: .number.precision(.fractionLength(0...1)))
      }
      TableColumn("Icon", value: \.estimate.icon.rawValue)
    }
    .task {
      do {
        try await load()
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  private func load() async throws {
    let estimates = state.estimates()
    let allProfiles = try await state.decent.getProfiles()
    for var referenceFile in allProfiles {
      if let contents = try? await state.decent.getProfile(referenceFile) {
        print(contents)
        // WIP
      }
      if referenceFile.hasSuffix(".json") {
        referenceFile = String(referenceFile.dropLast(5))
      }
      let estimate = estimates.estimates[referenceFile] ?? estimates.defaultEstimate
      await MainActor.run {
        profiles.append(ShotProfile(name: referenceFile, estimate: estimate))
      }
    }
  }
}

