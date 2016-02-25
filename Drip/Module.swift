public class Module: ModuleType {
  weak public var registrar: Registrar!
  
  public required init(_ registrar: Registrar) {
    self.registrar = registrar
  }
}