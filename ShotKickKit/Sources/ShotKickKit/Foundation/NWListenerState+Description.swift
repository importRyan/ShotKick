import Network

extension NWListener.State? {
  var displayValue: String {
    switch self {
    case .none: "Off"
    case .cancelled: "Cancelled"
    case .ready: "Ready"
    case .setup: "Setup"
    case .waiting(let error): error.localizedDescription
    case .failed(let error): error.localizedDescription
    @unknown default: "Unknown"
    }
  }
}
