/**
 Note: should only be referenced when implementing of custom generators

 Type used to match dependencies. A `Hashable` or `Any.Type` can be used to construct
 keys. Keys should have a 1-1 relationship to a dependency, but uniqueness is not
 enforced.
*/
public struct Key {
  private let value: Int

  /**
   Initializes a `Key` from a type.

   - Parameter type: a type to consturct the key from
   - Returns: A new key
  */
  public init(_ type: Any.Type) {
    self.init(String(type))
  }

  /**
   Initializes a key from a `Hashable`.

   - Parameter hashable: a `Hashable` object to construct the key from
   - Returns: A new key
  */
  public init<H: Hashable>(_ hashable: H) {
    value = hashable.hashValue
  }
}

// MARK: Hashable
extension Key: Hashable {
  public var hashValue: Int {
    return value
  }
}

// MARK: Equatable
public func ==(lhs: Key, rhs: Key) -> Bool {
  return lhs.value == rhs.value
}

// MARK: KeyConvertible
extension Key: KeyConvertible {
  public func key() -> Key {
    return self
  }
}