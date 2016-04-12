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

  // MARK: custom-keyed dependencies
  func inject() -> DependencyB {
    return single { DependencyB() }
  }

  func inject2() -> DependencyB {
    return single("alt") { DependencyB() }
  }

  // MARK: nested dependencies
  func inject() -> DependencyC {
    return transient {
      DependencyC(
        a: $0.root.core.inject(),
        b: $0.core.inject()
      )
    }
  }

  // MARK: inherited depdendencies
  func inject() -> TypeD {
    return single { DependencyD() as TypeD }
  }

  func inject2() -> TypeD {
    return single { DependencyD() }
  }

  // MARK: generic dependencies
  func inject<E: TypeE>(requirement: E.Requirement) -> E {
    return single { return E(requirement: requirement) }
  }
}