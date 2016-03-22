@testable import Drip

extension ComponentType {
  func resolve<T>(key: KeyConvertible = Key(T.self)) -> T? {
    let generator: (Self -> T)? = registry.get(key)
    return generator?(self)
  }
}