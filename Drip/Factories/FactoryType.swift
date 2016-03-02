/**
 Custom factories must conform to this protocol.

 Factories control how abitrary dependencies are constructed, and can
 implement custom behavior such as caching, sequencing, etc.
*/
public protocol FactoryType {
  /// The type of dependency the factory creates
  typealias Element
  /// The type of component resolving the dependency
  typealias Component: ComponentType

  /**
   Called when a dependency instance is requested.

   - Parameter component: The component requesting the instance
   - Returns: An instance of the factory's element
  */
  func create(component: Component) -> Element
}