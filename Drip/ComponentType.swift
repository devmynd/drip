public protocol ComponentType: class {
  var registry: Registry { get }
}

// MARK: Parents
public extension ComponentType {
  func parent<P: ComponentType>() -> P {
    return registry.get()
  }

  func parent<P: ComponentType>(initializer: () -> P) -> Self {
    registry.set(initializer())
    return self
  }
}

// MARK: Modules
public extension ComponentType {
  func module<M: ModuleType where M.Owner == Self>() -> M {
    return registry.get()
  }

  func module<M: ModuleType where M.Owner == Self>(type: M.Type, initializer: (Self) -> M) -> Self {
    registry.set(type, value: initializer(self))
    return self
  }
}

// MARK: Factories
extension ComponentType {
  func factory<F: FactoryType>(constructor: () -> F) -> F {
    var result: F
    
    if let factory: F = registry.get() {
      result = factory
    } else {
      result = constructor()
      registry.set(result)
    }
    
    return result
  }

  func resolve<F: FactoryType where F.Component == Self>(constructor: () -> F) -> F.Element {
    return factory(constructor).create(self)
  }
}