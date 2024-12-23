import Foundation

typealias Profile = String
typealias ProfileList = [String]

struct StatusDetailsDTO: Decodable {
  let state: String
  let substate: String
  let batteryPercent: Double
  let chargerOn: Bool
}

struct ShotListDTO: Decodable {
  let shots: [Shot]

  init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.shots = try container.decode([Shot].self)
  }

  struct Shot: Decodable {
    let beanBrand: String
    let beanDesc: String
    let beanNotes: String
    let beanType: String
    let clock: Date
    let drinkWeight: Double
    let espressoEnjoyment: String
    let espressoNotes: String
    let extractionTime: Double
    let filename: String
    let grinderDoseWeight: String
    let grinderModel: String
    let grinderSetting: String
    let profileTitle: String
    let shotDesc: String
    let targetDrinkWeight: Double
  }
}

struct ShotDTO: Decodable {
  let version: String
  let clock: String
  let date: String
  let timestamp: String
  let elapsed: [String]
  let timers: [String: String]
  let pressure: PressureData
  let flow: FlowData
  let temperature: TemperatureData
  let scale: [String: String]
  let totals: TotalsData
  let resistance: ResistanceData
  let stateChange: [String]
  let profile: ProfileData
  let meta: MetaData
//  let app: AppData

  struct PressureData: Decodable {
    let pressure: [String]
    let goal: [String]
  }

  struct FlowData: Decodable {
    let flow: [String]
    let byWeight: [String]
    let byWeightRaw: [String]
    let goal: [String]
  }

  struct TemperatureData: Decodable {
    let basket: [String]
    let mix: [String]
    let goal: [String]
  }

  struct TotalsData: Decodable {
    let weight: [String]
    let waterDispensed: [String]
  }

  struct ResistanceData: Decodable {
    let resistance: [String]
    let byWeight: [String]
  }

  struct ProfileData: Decodable {
    let title: String
    let author: String
    let notes: String
    let beverageType: String
    let steps: [Step]
    let tankTemperature: String
    let targetWeight: String
    let targetVolume: String
    let targetVolumeCountStart: String
    let legacyProfileType: String
    let type: String
    let lang: String
    let hidden: String
    let referenceFile: String
    let changesSinceLastEspresso: String
    let version: String

    struct Step: Decodable {
      let name: String
      let temperature: String
      let sensor: String
      let pump: String
      let transition: String
      let pressure: String
      let flow: String
      let seconds: String
      let volume: String
      let weight: String
      let limiter: Limiter?
      let exit: Exit?

      struct Limiter: Decodable {
        let value: String
        let range: String
      }

      struct Exit: Decodable {
        let type: String
        let condition: String
        let value: String
      }
    }
  }

  struct MetaData: Decodable {
    let bean: BeanData
    let shot: ShotData
    let grinder: GrinderData
    let `in`: String
    let out: String
    let time: String

    struct BeanData: Decodable {
      let brand: String
      let type: String
      let notes: String
      let roastLevel: String
      let roastDate: String
    }

    struct ShotData: Decodable {
      let enjoyment: String
      let notes: String
      let tds: String
      let ey: String
    }

    struct GrinderData: Decodable {
      let model: String
      let setting: String
    }
  }

  struct AppData: Decodable {
    let appName: String
    let appVersion: String
    let data: AppSettings

    struct AppSettings: Decodable {
      let settings: [String: String]
      let machineState: [String: String]
    }
  }
}
