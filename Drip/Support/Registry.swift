public class Registry {
  private let modules = Store()
  private let factories = Store()
  private let parents = Store()

  public init() {}
}

// MARK: Modules
extension Registry {
  func get<M: ModuleType>() -> M {
    return modules[M.self] as! M
  }

  func set<M: ModuleType>(type: M.Type, value: M?) {
    modules[type] = value
  }
}

// MARK: Factories
extension Registry {
  func get<F: FactoryType>() -> F? {
    return factories[F.Element.self] as? F
  }

  func set<F: FactoryType>(value: F?) {
    factories[F.Element.self] = value
  }
}

// MARK: Parents
extension Registry {
  func set<C: ComponentType>(value: C?) {
    parents[C.self] = value
  }

  func get<C: ComponentType>() -> C {
    return parents[C.self] as! C
  }
}