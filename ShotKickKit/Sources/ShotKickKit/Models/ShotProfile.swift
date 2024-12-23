struct ShotProfile: Identifiable {
  var id: String { name }
  let name: String
  let estimate: ShotEstimate
}
