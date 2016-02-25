public struct Key {
  private let type: Any.Type
  
  init(type: Any.Type) {
    self.type = type
  }
}

// MARK: Hashable
extension Key : Hashable {
  public var hashValue: Int {
    return String(self.type).hashValue
  }
}

// MARK: Equatable
public func ==(lhs: Key, rhs: Key) -> Bool {
  return lhs.type == rhs.type
}