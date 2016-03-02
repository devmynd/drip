/**
 Classes conforming to `ComponentType` are a container for a set of dependencies,
 declared in `Modules`, and are the principal mechanism for scoping dependencies
 to particular part of the application.
 
 A `ComponentType` owns modules, which can be registered through the chainable
 method `module`.
*/
public protocol ComponentType: class {
  /**
   The `registry` is used as the component's backing store. Conformance to the
   `ComponentType` only requires that the implementer declare storage for and
   construct a registry.
  */
  var registry: Registry { get }
}

// MARK: Parents
public extension ComponentType {
  /**
   Retrieves a registered parent component. If the parent component is not yet
   registerd, this method raises an exception.

   - Returns: A pre-registered parent of type `P`
  */
  func parent<P: ComponentType>() -> P {
    return registry.get()
  }

  /**
   Registers a parent component of type `P`. This component can be retrieved through
   the `parent` accessor method.

   - Parameter initializer: A closure called immediately that returns or initializes
     the parent, which is then discarded.

   - Returns: This component for chaining
  */
  func parent<P: ComponentType>(initializer: () -> P) -> Self {
    registry.set(initializer())
    return self
  }
}

// MARK: Modules
public extension ComponentType {
  /**
   Retrieves the module registered for the module type `M`. If no module has been
   registerd for `M`, this method raises an exception.
   
   `M` must decare this component as it's `Owner`.

   - Returns: A pre-registered module of type `M`
  */
  func module<M: ModuleType where M.Owner == Self>() -> M {
    return registry.get()
  }

  /**
   Registers a module of type `M`. This module can be retrieved through the `module` 
   accessor method.
   
   - Parameter type: The supertype (or the type itself) of the module to register
   - Parameter initializer: A closure called immediately that returns or initializes
   the module, which is then discarded. Passed this component as its only parameter.

   - Returns: This component for chaining
  */
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