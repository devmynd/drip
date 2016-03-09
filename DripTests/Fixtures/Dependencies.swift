class DependencyA {

}

class DependencyB {

}

class DependencyC {
  let a: DependencyA
  let b: DependencyB

  init(a: DependencyA, b: DependencyB) {
    self.a = a
    self.b = b
  }
}