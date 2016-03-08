import Drip

class Component1: ComponentType {
  let registry = Registry()
  func core() -> Module1 { return module() }
}

class Component2: ComponentType {
  let registry = Registry()
}