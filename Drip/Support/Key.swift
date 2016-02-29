struct Key {
  private let type: Any.Type
  
  init(_ type: Any.Type) {
    self.type = type
  }
}

// MARK: Hashable
extension Key: Hashable {
  var hashValue: Int {
    return String(self.type).hashValue
  }
}

// MARK: Equatable
func ==(lhs: Key, rhs: Key) -> Bool {
  return lhs.type == rhs.type
}