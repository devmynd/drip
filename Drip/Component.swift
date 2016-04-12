
/// Base class for components. Functionality provided by `ComponentType`.
public class Component: ComponentType {
  public let registry = Registry()
  public required init() {}
}