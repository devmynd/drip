
import Quick
import Nimble

@testable import Drip

class ComponentIntegrationSpec: QuickSpec {
  override func spec() {
    var parent:  ComponentA!
    var subject: ComponentB!

    beforeEach {
      parent = ComponentA()
        .module { ModuleA($0) }

      subject = ComponentB()
        .parent { parent }
        .module { ModuleB($0) }
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

    describe("a dependency with an inferred key") {
      context("presently") {
        beforeEach {
          subject.core.inject() as TypeD
        }

        it("uses the generator's return type as its key") {
          let result: TypeD? = subject.resolve()
          expect(result).toNot(beNil())
        }
      }

      context("ideally") {
        beforeEach {
          subject.core.inject2() as TypeD
        }

        xit("uses the _declared_ return type as its key") {
          let result: TypeD? = subject.resolve()
          expect(result).toNot(beNil())
        }
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

      it("does not resolve to a dependency with an inferred key of its type") {
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

    describe("a genericized dependency") {
      let requirement = Req1()
      var instance: DependencyE<Req1>!

      beforeEach {
        instance = subject.core.inject(requirement) as DependencyE<Req1>
      }

      it("resolves through its module") {
        let result: DependencyE<Req1> = subject.core.inject(requirement)
        expect(result) === instance
      }
    }
  }
}