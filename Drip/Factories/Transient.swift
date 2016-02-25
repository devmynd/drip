class Transient<T>: FactoryType {
  typealias Element = T
  
  private var generator: () -> T
  
  init(generator: () -> T) {
    self.generator = generator
  }
  
  func create() -> T {
    return self.generator()
  }
}