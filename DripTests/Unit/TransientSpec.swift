@testable import Drip

import Nimble
import Quick

class TransientSpec: QuickSpec {
  override func  spec() {
    var subject: Transient<Dependency1, Component1>!
    var component: Component1!

    beforeEach {
      subject = Transient { _ in return Dependency1() }
      component = Component1()
    }

    describe("create") {
      var instance: Dependency1!

      beforeEach {
        instance = subject.create(component)
      }

      it("returns a new instance") {
        expect(subject.create(component)) !== instance
      }
    }
  }
}