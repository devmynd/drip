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
      var factory: Transient<DependencyB, ComponentB>!

      beforeEach {
        factory = Transient { _ in DependencyB() }
      }

      context("with an instance") {
        var instance: DependencyB!

        beforeEach {
          instance = DependencyB()
          subject.override(instance as DependencyB)
        }

        it("always resolves that instance") {
          let result = subject.resolve { factory }
          expect(result) === instance
        }
      }

      context("with a generator") {
        var instance: DependencyB!

        beforeEach {
          instance = DependencyB()
          subject.override { _ in instance as DependencyB }
        }

        it("reolves to the generator instance") {
          let result = subject.resolve { factory }
          expect(result) === instance
        }
      }

      context("with a factory") {
        var instance: DependencyB!

        beforeEach {
          instance = DependencyB()
          subject.override(Transient { (_: ComponentB) in instance as DependencyB })
        }

        it("resolves to the factory instance") {
          let result = subject.resolve { factory }
          expect(result) === instance
        }
      }
    }
  }
}