class Single<T> : FactoryType {
  typealias Element = T
  
  private var instance: T?
  private let generator: () -> T
  
  init(generator: () -> T) {
    self.generator = generator
  }
  
  func create() -> T {
    if self.instance == nil {
      self.instance = self.generator()
    }
    
    return self.instance!
  }
}