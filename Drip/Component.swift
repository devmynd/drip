public protocol ComponentType: Registrar {
  var modules:   Registry { get }
  var factories: Registry { get }
  
  init(initializers: [Key: (Registrar) -> ModuleType])
}

//
// MARK: Modules

public extension ComponentType {
  func module<M>() -> M {
    let module = modules[M.self] as! M
    return module
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
  
  func resolve(initializers: [Key: (Registrar) -> ModuleType]) {
    for (key, initializer) in initializers {
      modules[key] = initializer(self)
    }
  }
}

//
// MARK: Building

public extension ComponentType {
  static func setup() -> BuilderOf<Self> {
    return BuilderOf()
  }
}

public class BuilderOf<C: ComponentType> {
  var initializers: [Key: (Registrar) -> ModuleType]
  
  public init() {
    initializers = Dictionary<Key, (Registrar) -> ModuleType>()
  }
  
  public func module<M: ModuleType>(key: M.Type, _ initializer: (Registrar) -> M) -> Self {
    initializers[Key(type: key)] = initializer
    return self
  }
  
  public func build() -> C {
    return C(initializers: initializers)
  }
}