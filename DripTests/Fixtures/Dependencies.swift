
// MARK: Dependency Nesting
class DependencyA {}
class DependencyB {}
class DependencyC {
  let a: DependencyA
  let b: DependencyB

  init(a: DependencyA, b: DependencyB) {
    self.a = a
    self.b = b
  }
}

// MARK: Dependency Inheritance
protocol TypeD {}
class DependencyD: TypeD {}

// MARK: Dependency Genericization
protocol TypeR {}

struct Req1: TypeR {}
struct Req2: TypeR {}

protocol TypeE {
  associatedtype Requirement: TypeR
  init(requirement: Requirement)
}

class DependencyE<R: TypeR>: TypeE {
  typealias Requirement = R
  required init(requirement: R) {
  }
}