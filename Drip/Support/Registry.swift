/** 
 Registry encapsulating a component's storage. Classes conforming to
`ComponentType` should declare and instantiate a registry, i.e.
 
 `let registry = Registry()`
*/
public class Registry {
  private let modules = Store()
  private let generators = Store()
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

// MARK: Generators
extension Registry {
  func get<C: ComponentType, T>() -> ((C) -> T)? {
    return generators[T.self] as? (C) -> T
  }

  func set<C: ComponentType, T>(value: ((C) -> T)) {
    generators[T.self] = value
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