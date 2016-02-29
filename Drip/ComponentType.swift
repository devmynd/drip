public protocol ComponentType: class {
  var modules:   Registry { get }
  var factories: Registry { get }
}

//
// MARK: Modules

public extension ComponentType {
  func module<M>() -> M {
    let module = modules[M.self] as! M
    return module
  }

  func resolve(initializers: [Key: (Self) -> Any]) {
    for (key, initializer) in initializers {
      modules[key] = initializer(self)
    }
  }
}

//
// MARK: Registrar

public extension ComponentType {
  func factory<F: FactoryType>(constructor: () -> F) -> F {
    var result: F
    
    let type = F.Element.self
    if let factory = factories[type] as! F? {
      result = factory
    } else {
      result = constructor()
      factories[type] = result
    }
    
    return result
  }
}

//
// MARK: Building

public protocol Buildable {
  init(initializers: [Key: (Self) -> Any])
}

public class BuilderOf<C: ComponentType where C: Buildable> {
  var initializers: [Key: (C) -> Any]
  
  public init() {
    initializers = Dictionary<Key, (C) -> Any>()
  }
  
  public func module<M: ModuleType>(key: M.Type, _ initializer: (C) -> M) -> Self {
    initializers[Key(type: key)] = initializer
    return self
  }
  
  public func build() -> C {
    return C(initializers: initializers)
  }
}

public extension ComponentType where Self: Buildable {
  static func setup() -> BuilderOf<Self> {
    return BuilderOf()
  }
}