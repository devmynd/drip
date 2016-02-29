public protocol ModuleType {
  typealias Component: ComponentType
  weak var component: Component! { get }
  init(_ component: Component)
}

extension ModuleType {
  public func single<T>(generator: () -> T) -> T {
    return single { (_: Component) in generator() }
  }

  public func single<T>(generator: (Component) -> T) -> T {
    let factory = component.factory { Single(generator: generator) }
    return factory.create(component)
  }
  
  public func transient<T>(generator: () -> T) -> T {
    return transient { (_: Component) in generator() }
  }

  public func transient<T>(generator: (Component) -> T) -> T {
    let factory = component.factory { Transient(generator: generator) }
    return factory.create(component)
  }
}