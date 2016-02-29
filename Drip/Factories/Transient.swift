class Transient<E, C: ComponentType>: FactoryType {
  typealias Element = E
  
  private var generator: (C) -> E
  
  init(generator: (C) -> E) {
    self.generator = generator
  }
  
  func create(component: C) -> E {
    return self.generator(component)
  }
}