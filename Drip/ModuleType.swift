/**
 A module encapsulates a subset of a component's provide dependencies. Modules 
 are registered to a component, and must conform to `ModuleType`.
 
 Dependencies are declared as standard methods, and should register a factory
 using the `single`, `transient` or a custom factory helper to control the
 dependency's scope:

 A base implementation is provided by the type `Module`.
*/
public protocol ModuleType {
  /// The type of the component that manages this module
  typealias Owner: ComponentType

  /** 
   The component that owns this module, passed to the module through its
   initializer.
  */
  weak var component: Owner! { get }

  /**
   The registered initializer for all `ModuleType`s. Implementers should
   store the paramterized component so that dependencies can be correctly
   resolved.
   
   - Parameter component: The component owning this module.
  */
  init(_ component: Owner)
}

extension ModuleType {
  /**
   Registers a dependency. The dependency is lazily evaluated, and only one instance
   will be constructed per component.
   
   - Parameter generator: A closure that returns an instance of the dependency
   
   - Returns: An instance of the dependency
  */
  public func single<T>(generator: () -> T) -> T {
    return single { (_: Owner) in generator() }
  }

  /**
   Registers a dependency. The dependency is lazily evaluated, and only one instance
   will be constructed per component.
   
   - Parameter generator: A closure that returns an instance of the dependency and
     is passed the owning component to resolve child dependencies.
   
   - Returns: An instance of the dependency
  */
  public func single<T>(generator: (Owner) -> T) -> T {
    return component.resolve { Single(generator) }
  }

  /**
   Registers a dependency. The dependency is lazily evaluated, and is created
   on-demand each time it's requested.

   - Parameter generator: A closure that returns an instance of the dependency and
     is passed the owning component to resolve child dependencies.
   
   - Returns: An instance of the dependency
  */ 
  public func transient<T>(generator: () -> T) -> T {
    return transient { (_: Owner) in generator() }
  }

  /**
   Registers a dependency. The dependency is lazily evaluated, and is created
   on-demand each time it's requested.

   - Parameter generator: A closure that returns an instance of the dependency

   - Returns: An instance of the dependency
  */
  public func transient<T>(generator: (Owner) -> T) -> T {
    return component.resolve { Transient(generator) }
  }

  /**
   Registers a placeholder dependency. If this dependency is requested, it raises
   an exception instead.

   - Returns: An application crash
  */
  public func abstract<T>() -> T {
    return Abstract().create(component)
  }
}