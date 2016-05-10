# Drip

A lightweight, dagger-ish dependency injection framework for Swift. May `sharedInstance` blot your vision nevermore.

Dependencies are resolved through type inference whenever possible. Two types, `Components` and `Modules`, compose the dependency container. At a high level, a `Module` provides specific dependencies, and a `Component` both contains a set of `Modules` and constrains their scope.

### Modules

A module provides, and is a logical grouping of, related dependencies. For example, in your application you might define a `ServiceModule` that provides a set of `Api` objects.

A module is a class conforming to `ModuleType`, but typically subclassing `Module`. A module is coupled to a specific component, and it must specify that component in its type declaration. 

```
import Drip

class ViewModule: Module<ViewComponent> {
  required init(_ component: ViewComponent) {
    super.init(component)
  }
}
```

A module declares methods describing the strategy to resolve individual dependencies. At present, modules have two built-in strategies (exposed as instance methods on the module) for resolving dependencies:

- `single`: Only one instance is created per-component.
- `transient`: A new instance is created per-resolution. 

The strategy methods receive the component as their only parameter. In the event that a dependency requires other objects contained by the module's component, you can this parameter be used to inject any nested dependencies.

```
func inject() -> Api {
  return transient { Api() }
}

func inject() -> ViewModel {
  return single { c in
    ViewModel(api: c.core.inject())
  }
}
```

### Components

A `Component` constrains the scope for a set of modules, and is the container for the modules' dependencies. Components have no built-in lifecycle, but are instead owned by (and match the lifecycle of) a member of your application. A component serves dependencies appropriate for the scope of its owning object.

For example, an `Application` object might own an `ApplicationComponent` that serves application-wide dependencies like a `Repository` and a `Configuration`.

A component is a class conforming to `ComponentType`, but typically subclassing `Component`.

```
import Drip

final class ViewComponent: Component {
  var root: ApplicationComponent { return parent() }
  var core: ViewModule { return module() }
}
```

A component declares accessors for referencing its modules (the `module` method will automatically resolve the correct instance).

```
var core: ViewModule { return module() }
```

A component may also declare accessors for referencing parent components (the `parent` method will automatically resolve the correct instance). This is useful when declaring a component with a narrower scope that requires dependencies provided by a wider-scoped component.

```
var root: ApplicationComponent { return parent() }
```

Components are constrcuted through chainable methods that register its modules (and optionally parents). The type of parents is inferred, but the type of modules must be specified explicitly.

```
lazy var component: ViewComponent = ViewComponent()
  .parent { self.app.component }
  .module(ViewModule.self) { ViewModule($0) }
```
