
import Quick
import Nimble

@testable import Drip

class RegistrySpec: QuickSpec {
  override func spec() {
    var subject: Registry!

    beforeEach {
      subject = Registry()
    }

    describe("#get for components") {
      var component: ComponentB!

      beforeEach {
        component = ComponentB()
        subject.set(component)
      }

      it("retrieves stored components") {
        expect(try? subject.get() as ComponentB) === component
      }

      it("throws a fatal error when a matching component is not registered") {
        expect {
          try subject.get() as ComponentA
        }.to(throwError(Error.ComponentNotFound(type: ComponentA.self)))
      }
    }

    describe("#get for modules") {
      let key = Key(ModuleB.self)
      var module: ModuleB!

      beforeEach {
        module = ModuleB(ComponentB())
        subject.set(key, value: module)
      }

      it("retrieves stored modules") {
        expect(try? subject.get(key) as ModuleB) === module
      }

      context("when a matching module is not registered") {
        it("throws an error") {
          expect {
            try subject.get(key) as ModuleA
          }.to(throwError(Error.ModuleNotFound(type: ModuleA.self)))
        }
      }
    }

    describe("#get for generators") {
      typealias GeneratorA = ComponentA -> DependencyA
      typealias GeneratorB = ComponentB -> DependencyB

      var keyA: Key!
      var keyB: Key!

      beforeEach {
        keyA = Key(DependencyA.self)
        keyB = Key(DependencyB.self)

        subject.set(keyA, value: { _ in DependencyA() } as GeneratorA)
      }

      it("retrieves stored generators") {
        expect(subject.get(keyA) as GeneratorA?).toNot(beNil())
      }

      it("returns nil when a matching factory is not registered") {
        expect(subject.get(keyB) as GeneratorB?).to(beNil())
      }
    }
  }
}