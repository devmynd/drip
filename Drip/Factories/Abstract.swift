struct Abstract<E, C: ComponentType>: FactoryType {
  typealias Element = E
  typealias Component = C

  func create(component: C) -> E {
    fatalError("Failed to implement abstract factory for \(E.self)")
  }
}