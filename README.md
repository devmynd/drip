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
func inject() -> DataStore {
  return transient { DataStore() } // ignore the `transient` bit for now
}
```

Dependencies must also be part of a _container_ that manages the resolution of any provided dependencies. The container is typically an instance of `Component`, and it is organized into modules that encapsulate sets of dependencies. Typically, modules are instances of `Module`, and they are bound to a specific component.

```swift
class AppComponent: Component {
  var main: MainModule { return module() }
}

class MainModule: Module<AppComponent> {
  required init(_ component: AppComponent) { super.init(component) }
  
  func inject() -> DataStore {
    return transient { DataStore() } // continue to ignore the `transient` bit
  }
}
```

There is no singleton accessor for `Component`, this is by design. If you want to instantiate any of the component's provided dependencies, you need an instance of the component, and it needs instances of its modules.

```swift
let component = AppComponent().module { MainModule($0) }
let store: DataStore = component.main.inject() // yay
```

#### Scoping
Sometimes you need to provide a single instance of a dependency to multiple objects in your graph. Components provide the means to scope such dependencies to a layer of your application so that they don't need to be globally accessible.

Rather than create components on-demand, as in the previous example, a member of your application should own the component. For example, an `AppComponent` that provide app-wide dependencies (like a data store) is probably owned by your application object:

```swift
class AppDelegate: UIApplicationDelegate {
  lazy var component = AppComponent()
    .module { MainModule($0) }
  ...
}
```

That's nice. In our module we can then use factory methods (`single`, `transient`) to control the lifetime of individual dependencies within a component:

```swift
class MainModule: Module<AppComponent> {
  ...
  func inject() -> DataStore {
    // only one instance of a `single` dependency is created per-component
    return single { DataStore() }
  }

  func inject() -> Service {
    // a new instance of a `transient` dependency is created per-resolution
    return transient { Service() }
  }
}
```

#### Nested Dependencies
If one of your prodvided objects depends on another object in the graph, you can do that too! A module's owning component is passed to the factory methods during dependency resolution:

```swift
class AppComponent: Component {
  var main: MainModule { module() }
}

class MainModule: Module<AppComponent> {
  ...
  func inject() -> DataStore ...

  func inject() -> Service {
    return transient { c in // AppComponent; parameter name is your choice, enjoy!
      Service(store: c.main.store())
    }
  }
}
```

#### Component Relationships
Components can relate to other components and gain access to their dependencies. You can express this using the component's `parent` method:

```swift
class ViewComponent: Component {
  var app:  AppComponent { parent() }
  var view: ViewModule   { module() }
}

class ViewController: UIViewController {
  lazy var component: ViewComponent = ViewComponent()
    .parent { self.app.component } // how you obtain the reference to the parent component is your decision
    .module { ViewModule($0) }
}
```

In this example, you can now provide view-scoped dependencies that depend on objects provided by your app component:

```swift
struct ViewModel {
  init(service: Service) ...
}

class ViewModule: Module<ViewComponent> {
  ...
  fun inject() -> ViewModel {
    return single { c in
      ViewModel(service: c.app.main.inject())
    }
  }
}
```

#### Generics
If you have dependencies with generic parameters, it's easiest to pass them in through individual provider methods. If you had a `Presenter` that required a generic view `V`, it might look something like:

```swift
class ViewModule: Module<ViewComponent> {
  ...
  fun inject<V: ViewType>(view view: V) -> Presnter<V> {
    return single { c in 
      Presenter(
        view:    view, 
        service: c.app.main.inject()) 
    }
  }
}
```

#### Testing
When testing, you'll often want to use mock instances of your dependencies. 

The easiest way to do this is to substitute mocks for individual depenencies in your test setup using the `override` method:

```swift
component.override(MockService() as Service)

// if you can pass in the dependency directly, great
let view = MockView() 

// view: MockView, service: MockService
let presenter: Presenter<MockView> = component.view.inject(view: view) 
```

If you want to mock a whole module, you can provide a subtype of your module that returns mock instances instead of live ones:

```swift
// you'll probably want MainModule to be a protocol in this case
class MockMainModule: MainModule {
  ...
  fun inject() -> Repo {
    return transient { MockRepo() as Repo }
  }
}

let component = AppComponent().module { MockMainModule($0) as MainModule }
let repo: Repo = component.main.inject() // MockRepo
```

#### Gotchas
Drip uses types to key dependencies, modules, and related components. As you start overriding parts of your object graph, you'll need to upcast objects to some shared ancestor. You'll notice this is done many places in the last couple examples. I haven't found a way to solve this problem at the library-level, but I'd like to.
