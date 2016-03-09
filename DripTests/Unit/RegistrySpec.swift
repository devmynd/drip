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
      var module: ModuleB!

      beforeEach {
        module = ModuleB(ComponentB())
        subject.set(Module.self, value: module)
      }

      it("retrieve stored modules") {
        expect(subject.get() as Module) === module
      }

      xit("throw a fatal error when a matching module is not registered") {
        expect { subject.get() as ComponentA }.to(raiseException())
      }
    }

    describe("factory setter/getters") {
      var factory: Single<DependencyB, ComponentB>!

      beforeEach {
        factory = Single { _ in DependencyB() }
        subject.set(factory)
      }

      it("retrieve stored factories") {
        expect(subject.get() as Single<DependencyB, ComponentB>?) === factory
      }

      it("return nil when a matching factory is not registered") {
        expect(subject.get() as Single<DependencyB, ComponentB>?) === factory
      }
    }

    describe("component setter/getters") {
      var component: ComponentB!

      beforeEach {
        component = ComponentB()
        subject.set(component)
      }

      it("retrieve stored components") {
        expect(subject.get() as ComponentB) === component
      }

      xit("throw a fatal error when a matching component is not registered") {
        expect { subject.get() as ComponentA }.to(raiseException())
      }
    }
  }
}