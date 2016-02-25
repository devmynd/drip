public class Registry {
  private var store = [Key: Any]()
  
  public init() {}
  
  subscript(type: Any.Type) -> Any? {
    get { return self[Key(type: type)] }
    set { self[Key(type: type)] = newValue }
  }
  
  subscript(key: Key) -> Any? {
    get { return store[key] }
    set { store[key] = newValue }
  }
}