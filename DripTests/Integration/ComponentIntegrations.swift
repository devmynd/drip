import Quick
import Nimble

class ComponentIntegrationSpec: QuickSpec {
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

      it("is resolved through its module") {
        let result: DependencyB = subject.core.inject()
        expect(result) === instance
      }
    }

    describe("a transient dependency") {
      var instance: DependencyC!

      beforeEach {
        instance = subject.core.inject()
      }

      it("is resolved through its module") {
        let result: DependencyC = subject.core.inject()
        expect(result) !== instance
      }
    }

    describe("a nested dependency within the component") {
      var nested: DependencyB!

      beforeEach {
        nested = subject.core.inject()
      }

      it("is resolved through its module") {
        let result: DependencyC = subject.core.inject()
        expect(result.b) === nested
      }
    }

    describe("a nested dependency within a parent component") {
      var nested: DependencyA!

      beforeEach {
        nested = parent.core.inject()
      }

      it("is resolved through the module") {
        let result: DependencyC = subject.core.inject()
        expect(result.a) === nested
      }
    }
  }
}