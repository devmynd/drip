/**
 Note: should only be used to implement of custom generators

 Type used to match dependencies. Any `String` and raw `Any.Type`s can be used to
 construct keys.

 As keys are used to match dependencies, they should be unique. Collisions will
 result in a component resolving incorrect dependencies.
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
   Initializes a key from anything `Hashable`.

   - Parameter hashable: a hashable object to construct the key from
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