/**
 Types conforming to `KeyConvertible` must be able to construct a `key` used
 to match dependencies.

 Default conformance for `String` and `Key` types is provided.

 See: `Key` for more documentation on their usage.
*/
public protocol KeyConvertible {
  /**
   Constructs a `Key` used to match dependencies.
   - Returns: A key instance corresponding to this object
  */
  func key() -> Key
}

public extension Hashable where Self: KeyConvertible {
  func key() -> Key {
    return Key(self)
  }
}

extension String: KeyConvertible {
}