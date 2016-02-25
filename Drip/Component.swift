public class Component: ComponentType {
  public var modules   = Registry()
  public var factories = Registry()
  
  public required init(initializers: [Key : (Registrar) -> ModuleType]) {
    self.resolve(initializers)
  }
  
  func resolve(initializers: [Key: (Registrar) -> ModuleType]) {
    for (key, initializer) in initializers {
      modules[key] = initializer(self)
    }
  }
}