class Store {
  private var store = [Key: Any]()

  init() {}

  subscript(type: Any.Type) -> Any? {
    get { return store[Key(type)] }
    set { store[Key(type)] = newValue }
  }
}