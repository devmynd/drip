public class Module<C: ComponentType>: ModuleType {
  public typealias Comp = C
  public weak var component: C!
  
  public required init(_ component: C) {
    self.component = component
  }
}