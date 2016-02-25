public protocol FactoryType {
  typealias Element
  func create() -> Element
}