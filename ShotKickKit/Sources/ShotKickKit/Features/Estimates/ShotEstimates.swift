struct ShotEstimates {
  let estimates: [String: ShotEstimate] = [
    "Extractamundo_Dos": ShotEstimate(icon: .espresso, caffeineMg: 30, waterMl: 40),
    "rao_allonge": ShotEstimate(icon: .brew, caffeineMg: 30, waterMl: 180)
  ]

  let defaultEstimate = ShotEstimate(icon: .espresso, caffeineMg: 30, waterMl: 36)
}
