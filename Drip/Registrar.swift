public protocol Registrar: class {
  func factory<F: FactoryType>(initializer: () -> F) -> F
}