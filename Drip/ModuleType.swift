public protocol ModuleType {
  typealias Owner: ComponentType
  weak var component: Owner! { get }
  init(_ component: Owner)
}

extension ModuleType {
  public func single<T>(generator: () -> T) -> T {
    return single { (_: Owner) in generator() }
  }

  public func single<T>(generator: (Owner) -> T) -> T {
    return component.resolve { Single(generator: generator) }
  }
  
  public func transient<T>(generator: () -> T) -> T {
    return transient { (_: Owner) in generator() }
  }

  public func transient<T>(generator: (Owner) -> T) -> T {
    return component.resolve { Transient(generator: generator) }
  }
}