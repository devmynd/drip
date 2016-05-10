
import Drip

final class ComponentA: Component {
  var core: ModuleA { return module() }
}

final class ComponentB: Component {
  var root: ComponentA { return parent() }
  var core: ModuleB { return module() }
}