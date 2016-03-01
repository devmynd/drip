import Drip

class TestComponent: ComponentType {
  let registry = Registry()
  func core() -> TestModule { return module() }
}