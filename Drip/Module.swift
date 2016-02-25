public protocol ModuleType {
  weak var registrar: Registrar! { get }
  init(registrar: Registrar)
}

extension ModuleType {
  public func single<T>(generator: () -> T) -> T {
    let factory = registrar.factory { Single(generator: generator) }
    return factory.create()
  }
  
  public func transient<T>(generator: () -> T) -> T {
    let factory = registrar.factory { Transient(generator: generator) }
    return factory.create()
  }
}