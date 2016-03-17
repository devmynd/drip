/** 
 Registry encapsulating a component's storage. Classes conforming to
`ComponentType` should declare and instantiate a registry, i.e.
 
 `let registry = Registry()`
*/
public class Registry {
  private let modules    = Store()
  private let parents    = Store()
  private let generators = Store()

  public init() {}
}

// MARK: Parents
extension Registry {
  func get<C: ComponentType>() throws -> C {
    guard let parent = parents[C.self] as? C else {
      throw Error.ComponentNotFound(type: C.self)
    }

    return parent
  }

  func set<C: ComponentType>(value: C?) {
    parents[C.self] = value
  }
}

// MARK: Modules
extension Registry {
  func get<M: ModuleType>() throws -> M {
    guard let module = modules[M.self] as? M else {
      throw Error.ModuleNotFound(type: M.self)
    }

    return module
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