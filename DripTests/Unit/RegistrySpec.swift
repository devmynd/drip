@testable import Drip

import Quick
import Nimble

class RegistrySpec: QuickSpec {
  override func spec() {
    var subject: Registry!

    beforeEach {
      subject = Registry()
    }

    describe("module setter/getters") {
      var module: Module1!

      beforeEach {
        module = Module1(Component1())
        subject.set(Module.self, value: module)
      }

      it("retrieve stored modules") {
        expect(subject.get() as Module) === module
      }

      xit("throw a fatal error when a matching module is not registered") {
        expect { subject.get() as Component2 }.to(raiseException())
      }
    }

    describe("factory setter/getters") {
      var factory: Single<Dependency1, Component1>!

      beforeEach {
        factory = Single { _ in Dependency1() }
        subject.set(factory)
      }

      it("retrieve stored factories") {
        expect(subject.get() as Single<Dependency1, Component1>?) === factory
      }

      it("return nil when a matching factory is not registered") {
        expect(subject.get() as Single<Dependency1, Component1>?) === factory
      }
    }

    describe("component setter/getters") {
      var component: Component1!

      beforeEach {
        component = Component1()
        subject.set(component)
      }

      it("retrieve stored components") {
        expect(subject.get() as Component1) === component
      }

      xit("throw a fatal error when a matching component is not registered") {
        expect { subject.get() as Component2 }.to(raiseException())
      }
    }
  }
}