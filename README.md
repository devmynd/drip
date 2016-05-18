# Drip

A lightweight, dagger-ish dependency injection library for Swift. Instantiate scoped, maybe even shared dependencies without littering managers `sharedInstances` and `-Managers`.

## Installation

Available via [Cocoapods](https://cocoapods.org/?q=drip), add the following to your `Podfile`:

```ruby
pod 'Drip', '~> 0.1'
```

## Usage
Dependencies are provided through methods, like so:

```swift
func store() -> DataStore {
  return transient { DataStore() } // ignore the `transient` bit for now
}
```

Dependencies must also be part of a _container_ that manages the resolution of any provided dependencies. The container is typically an instance of `Component`, and it is organized into modules that encapsulate sets of dependencies. Typically, modules are instances of `Module` that are bound to a specific component.

```swift
class AppComponent: Component {
  var data: DataModule { return module() }
}

class DataModule<AppComponent> {
  required init(_ component: AppComponent) { super.init(component) }
  
  func store() -> DataStore {
    return transient { DataStore() } // continue to ignore the `transient` bit
  }
}
```

There is no singleton accessor for `Component`, this is by design. If you want to instantiate any of the component's provided dependencies, you need an instance of the component, and it needs instances of its modules.

```swift
let component = AppComponent().module { DataModule($0) }
let store     = component.data.store() // yay
```

It's tedious to create the component every time you want a dependency, and it's also not very useful. A member of your application should own an instance of the component. For an `AppComponent`, that's probably your application object.

#### Modules

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

Each strategy method receives the component as its only parameter. In the event that a dependency depends on other types provided by the module's component, you to inject them using this component reference.

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
