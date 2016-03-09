import Drip

class ComponentA: ComponentType {
  let registry = Registry()

  var core: ModuleA { return module() }
}

class ComponentB: ComponentType {
  let registry = Registry()

  var root: ComponentA { return parent() }
  var core: ModuleB { return module() }
}