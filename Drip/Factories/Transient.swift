struct Transient<E, C: ComponentType>: FactoryType {
  typealias Element = E
  typealias Component = C
  
  private var generator: (C) -> E
  
  init(_ generator: (C) -> E) {
    self.generator = generator
  }
  
  func create(component: C) -> E {
    return self.generator(component)
  }
}