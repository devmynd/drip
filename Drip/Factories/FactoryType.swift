public protocol FactoryType {
  typealias Element
  typealias Component: ComponentType

  func create(component: Component) -> Element
}