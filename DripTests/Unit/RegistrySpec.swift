@testable import Drip

import Quick
import Nimble

class RegistrySpec: QuickSpec {
  override func spec() {
    var subject: Registry!

    beforeEach {
      subject = Registry()
    }

    describe("#get for modules") {
      var module: ModuleB!

      beforeEach {
        module = ModuleB(ComponentB())
        subject.set(Module.self, value: module)
      }

      it("retrieves stored modules") {
        expect(subject.get() as Module) === module
      }

      xit("throws a fatal error when a matching module is not registered") {
        expect { subject.get() as ComponentA }.to(raiseException())
      }
    }

    describe("#get for generators") {
      typealias GeneratorA = (ComponentA) -> DependencyA
      typealias GeneratorB = (ComponentB) -> DependencyB

      beforeEach {
        subject.set({ _ in DependencyA() } as GeneratorA)
      }

      it("retrieves stored generators") {
        expect(subject.get() as GeneratorA?).toNot(beNil())
      }

      it("returns nil when a matching factory is not registered") {
        expect(subject.get() as GeneratorB?).to(beNil())
      }
    }

    describe("#get for components") {
      var component: ComponentB!

      beforeEach {
        component = ComponentB()
        subject.set(component)
      }

      it("retrieves stored components") {
        expect(subject.get() as ComponentB) === component
      }

      xit("throws a fatal error when a matching component is not registered") {
        expect { subject.get() as ComponentA }.to(raiseException())
      }
    }
  }
}