@testable import Drip

import Quick
import Nimble

class ModuleSpec: QuickSpec {
  class TestModule: Module<Component1> {
    required init(_ component: Component1) {
      super.init(component)
    }
  }

  override func spec() {
    var subject: TestModule!
    var component: Component1!
    var dependency: Dependency1!

    beforeEach {
      component = Component1()
      subject = TestModule(component)
      dependency = Dependency1()
    }

    func itGenerates(factoryType: String, closure: () -> Dependency1) {
      var result: Dependency1!

      beforeEach {
        result = subject.single { return dependency }
      }

      it("generates \(factoryType)") {
        expect(result) === dependency
      }
    }

    describe("single") {
      itGenerates("single dependencies") {
        subject.single { return dependency }
      }
    }

    describe("transient") {
      itGenerates("transient dependencies") {
        subject.transient { return dependency }
      }
    }
  }
}