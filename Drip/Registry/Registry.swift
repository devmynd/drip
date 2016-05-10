/**
 Registry encapsulating a component's storage. Classes conforming to `ComponentType`
 should declare and instantiate a registry, i.e.

 `let registry = Registry()`
*/
public class Registry {
  private var modules    = [Key: Any]()
  private var parents    = [Key: Any]()
  private var generators = [Key: Any]()

  public init() {}
}

// MARK: Parents
extension Registry {
  func get<C: ComponentType>() throws -> C {
    guard let parent = parents[Key(C.self)] as? C else {
      throw Error.ComponentNotFound(type: C.self)
    }

    return parent
  }

  func set<C: ComponentType>(value: C?) {
    parents[Key(C.self)] = value
  }
}

// MARK: Modules
extension Registry {
  func get<M: ModuleType>(key: KeyConvertible) throws -> M {
    guard let module = modules[key.key()] as? M else {
      throw Error.ModuleNotFound(type: M.self)
    }

    return module
  }

  func set<M: ModuleType>(key: KeyConvertible, value: M?) {
    modules[key.key()] = value
  }
}

// MARK: Generators
extension Registry {
  func get<C: ComponentType, T>(key: KeyConvertible) -> (C -> T)? {
    return generators[key.key()] as? C -> T
  }

  func set<C: ComponentType, T>(key: KeyConvertible, value: C -> T) {
    generators[key.key()] = value
  }
}