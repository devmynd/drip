class Single<E, C: ComponentType>: FactoryType {
  typealias Element = E
  typealias Component = C
  
  private var instance: E?
  private let generator: (C) -> E
  
  init(generator: (C) -> E) {
    self.generator = generator
  }
  
  func create(component: C) -> E {
    if self.instance == nil {
      self.instance = self.generator(component)
    }
    
    return self.instance!
  }
}