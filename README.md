# drip

A lightweight, type-inferring Swift dependency injector inspired by Dagger.

At a high-level, dependencies are provided by a `Module` and a `Module` is scoped to a `Component`. A component is owned by a member of your application, and thus is tied to the lifecycle of that object.

Application-level dependencies, for example, could be stored by an `ApplicationComponent` that is owned by your `Application` object. View-level dependencies could be stored in a `ViewComponent` that is owned by a `ViewController`.

### TODO
- [ ] Backfill tests
- [ ] Work out strategy for genericizing modules
- [ ] Add hook for overriding dependencies at the component-level
- [x] Build examples for readme

### Modules

A module is a class conforming to `ModuleType`, but generally subclassing `Module`. It declares methods that register factories for constructing its provided dependencies. It's usually constructed when setting up a component.

```
import Drip

class ViewModule: Module<ViewComponent> {
  required init(_ component: ViewComponent) {
    super.init(component)
  }

  func inject() -> ViewModel {
    return single {
      ViewModel(api: $0.core.inject())
    }
  }

  func inject() -> Api {
    return transient {
      Api(repo: $0.parent.persistence.inject())
    }
  } 
}
```

### Components

A component is a class conforming to `ComponentType`, and it declares accessors for referening its modules and (optionally) parent components.

```
import Drip

final class ViewComponent: ComponentType {
  var registry = Registry()
  var parent: AppComponent { return parent() }
  var core: ViewModule { return module() }
}
```

A component can be constructed using chainable methods that register its parents and modules. It should be stored on the object that owns it.

```
lazy var component: ViewComponent = ViewComponent()
  .parent { self.app.component }
  .module(ViewModule.self) { ViewModule($0) }
```
