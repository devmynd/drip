struct Abstract<E, C: ComponentType>: FactoryType {
  typealias Element = E
  typealias Component = C

  func create(component: C) -> E {
    return (nil as E?)!
  }
}