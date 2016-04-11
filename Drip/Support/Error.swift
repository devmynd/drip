
enum Error: ErrorType {
  case ModuleNotFound(type: Any.Type)
  case ComponentNotFound(type: Any.Type)
}