import Quick
import Nimble

class ComponentIntegrations: QuickSpec {
  override func spec() {
    var parent: ComponentA!
    var subject: ComponentB!

    beforeEach {
      parent = ComponentA()
        .module(ModuleA.self) { ModuleA($0) }

      subject = ComponentB()
        .parent { parent }
        .module(ModuleB.self) { ModuleB($0) }
    }

    describe("a single dependency") {
      var instance: DependencyB!

      beforeEach {
        instance = subject.core.inject()
      }

      it("resolves through its module") {
        let result: DependencyB = subject.core.inject()
        expect(result) === instance
      }
    }

    describe("a transient dependency") {
      var instance: DependencyC!

      beforeEach {
        instance = subject.core.inject()
      }

      it("resolves through its module") {
        let result: DependencyC = subject.core.inject()
        expect(result) !== instance
      }
    }

    describe("a dependency with an explicit key") {
      var instance: DependencyB!

      beforeEach {
        instance = subject.core.inject2()
      }

      it("resolves through its module") {
        let result: DependencyB = subject.core.inject2()
        expect(result) === instance
      }

      it("does not resolve to any equivalently-typed, inferred dependency") {
        let other: DependencyB = subject.core.inject()
        expect(other) !== instance
      }
    }

    describe("a nested dependency within the component") {
      var nested: DependencyB!

      beforeEach {
        nested = subject.core.inject()
      }

      it("resolves through its module") {
        let result: DependencyC = subject.core.inject()
        expect(result.b) === nested
      }
    }

    describe("a nested dependency within a parent component") {
      var nested: DependencyA!

      beforeEach {
        nested = parent.core.inject()
      }

      it("resolves through its module") {
        let result: DependencyC = subject.core.inject()
        expect(result.a) === nested
      }
    }

    describe("an overridden dependency") {
      var instance: DependencyB!

      beforeEach {
        instance = DependencyB()
        subject.override(instance as DependencyB)
      }

      it("resolves through its module") {
        let result: DependencyB = subject.core.inject()
        expect(result) === instance
      }
    }
  }
}