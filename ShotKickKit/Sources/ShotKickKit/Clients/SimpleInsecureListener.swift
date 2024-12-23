import Foundation
import Network

final actor SimpleInsecureListener: Sendable {
  let state: AsyncStream<NWListener.State?>
  let received: AsyncStream<Result<Data, Error>>
  private let receivedContinuation: AsyncStream<Result<Data, Error>>.Continuation
  private let stateContinuation: AsyncStream<NWListener.State?>.Continuation
  private var listener: NWListener?
  private let queue: DispatchQueue

  init(queue: DispatchQueue = .server) {
    self.queue = queue
    (self.state, self.stateContinuation) = AsyncStream<NWListener.State?>.makeStream()
    (self.received, self.receivedContinuation) = AsyncStream<Result<Data, Error>>.makeStream()
  }
}

extension SimpleInsecureListener {

  func start(port: UInt16) throws {
    listener?.cancel()
    let listener = try NWListener(using: .tcp, on: NWEndpoint.Port(integerLiteral: port))

    listener.newConnectionHandler = { [weak self] newRequest in
      guard let self else { return }
      newRequest.start(queue: queue)
      newRequest.receive(
        minimumIncompleteLength: 0,
        maximumLength: 10_000_000
      ) { [weak newRequest, weak self] data, _, _, error in
        guard let data, let bodyIndex = data.firstIndex(of: UInt8(ascii: "{")) else { return }
        self?.receivedContinuation.yield(.success(data[bodyIndex...]))
        newRequest?.cancel()
      }
    }
    listener.stateUpdateHandler = { [weak self] newState in
      self?.stateContinuation.yield(newState)
    }

    listener.start(queue: queue)
    self.listener = listener
  }
}

extension DispatchQueue {
  static let server = DispatchQueue(label: "com.roastingapps.shotkickserver", attributes: .concurrent)
}
