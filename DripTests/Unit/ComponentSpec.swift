@testable import Drip

import Quick
import Nimble

class ComponentSpec: QuickSpec {
  override func spec() {
    var subject: ComponentB!

    func itRaises(error: String, trigger: (ComponentB) -> ()) {
      var subject: ComponentB!

      beforeEach {
        subject = ComponentB()
      }

      xit("throws a fatal error") {
        expect { trigger(subject) }.to(raiseException(named: error))
      }
    }

    describe("#parent") {
      context("when a parent is registered") {
        var parent: ComponentA!

        beforeEach {
          parent  = ComponentA()
          subject = ComponentB()
            .parent { parent }
        }

        it("retrieves the parent") {
          let result: ComponentA = subject.parent()
          expect(result) === parent
        }
      }

      context("when a parent is not registered") {
        itRaises("parent not registered") { subject in
          subject.parent() as ComponentA
        }
      }
    }

    describe("#module") {
      context("when a module is registered") {
        beforeEach {
          subject = ComponentB()
            .module(ModuleB.self) { ModuleB($0) }
        }

        it("retrieves the module") {
          let instance: ModuleB = subject.module()
          let result: ModuleB   = subject.module()

          expect(result) === instance
        }
      }

      context("when a module is not registered") {
        itRaises("module not registered") { subject in
          subject.module() as ModuleB
        }
      }
    }

    describe("#override") {
      var generator: (ComponentB -> DependencyB)!

      beforeEach {
        generator = { _ in DependencyB() }
      }

      context("with an instance") {
        var instance: DependencyB!

        beforeEach {
          instance = DependencyB()
          subject.override(instance as DependencyB)
        }

        it("always resolves that instance") {
          let result = subject.resolve(generator: generator)
          expect(result) === instance
        }
      }

      context("with a generator") {
        var instance: DependencyB!

        beforeEach {
          instance = DependencyB()
          subject.override { _ in instance as DependencyB }
        }

        it("resolves to the generator instance") {
          let result = subject.resolve(generator: generator)
          expect(result) === instance
        }
      }

      context("with an explicit key") {
        let key = "alt"
        var instance: DependencyB!

        beforeEach {
          instance = DependencyB()
          subject.override(key) { _ in instance as DependencyB }
        }

        it("resolves to the generator instance") {
          let result = subject.resolve(key, generator: generator)
          expect(result) === instance
        }
      }
    }

    describe("#resolve") {
      var evaluated: Bool!
      var generator: (ComponentB -> DependencyB)!

      beforeEach {
        subject = ComponentB()
          .module(ModuleB.self) { ModuleB($0) }

        evaluated = false
        generator = { _ in
          evaluated = true
          return DependencyB()
        }
      }

      context("when nothing is registered") {
        beforeEach {
          subject.resolve(generator: generator)
        }

        it("evaluates the parameterized generator") {
          expect(evaluated).to(beTrue())
        }
      }

      context("when something is already registered") {
        beforeEach {
          subject.resolve { _ in DependencyB() }
          subject.resolve(generator: generator)
        }

        it("does not evaluate the parameterized generator") {
          expect(evaluated).to(beFalse())
        }
      }
    }
  }
}