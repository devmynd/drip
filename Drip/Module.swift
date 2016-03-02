/**
 Genericized module supertype. Subclasses must specify the owning `ComponentType`
*/
public class Module<C: ComponentType>: ModuleType {
  public typealias Owner = C
  public weak var component: C!

  public required init(_ component: C) {
    self.component = component
  }
}