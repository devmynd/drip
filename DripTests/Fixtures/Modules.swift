import Drip

class ModuleA: Module<ComponentA> {
  required init(_ component: ComponentA) {
    super.init(component)
  }

  func inject() -> DependencyA {
    return single { DependencyA() }
  }
}

class ModuleB: Module<ComponentB> {
  required init(_ component: ComponentB) {
    super.init(component)
  }

  func inject() -> DependencyB {
    return single { DependencyB() }
  }

  func inject() -> DependencyC {
    return transient {
      DependencyC(
        a: $0.root.core.inject(),
        b: $0.core.inject()
      )
    }
  }
}