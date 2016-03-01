@testable import Drip

import Nimble
import Quick

class TransientSpec: QuickSpec {
  override func  spec() {
    var subject: Transient<Dependency, TestComponent>!
    var component: TestComponent!

    beforeEach {
      subject = Transient { _ in return Dependency() }
      component = TestComponent()
    }

    describe("create") {
      var instance: Dependency!

      beforeEach {
        instance = subject.create(component)
      }

      it("returns a new instance") {
        expect(subject.create(component)) !== instance
      }
    }
  }
}