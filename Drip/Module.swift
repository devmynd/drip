
/// Base class for modules. Functionality provided by `ModuleType`.
public class Module<C: ComponentType>: ModuleType {
  public typealias Owner = C
  public weak var component: C!
  public required init(_ component: C) {
    self.component = component
  }
}