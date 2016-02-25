public protocol ModuleType {
  weak var registrar: Registrar! { get }
  init(_ registrar: Registrar)
}

extension ModuleType {
  public func single<T>(generator: () -> T) -> T {
    return registrar.factory { Single(generator: generator) }.create()
  }
  
  public func transient<T>(generator: () -> T) -> T {
    return registrar.factory { Transient(generator: generator) }.create()
  }
}
