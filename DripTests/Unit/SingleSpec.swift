@testable import Drip

import Quick
import Nimble

class SingleSpec: QuickSpec {
  override func spec() {
    var subject: Single<Dependency1, Component1>!
    var component: Component1!

    beforeEach {
      subject = Single { _ in return Dependency1() }
      component = Component1()
    }

    describe("create") {
      var instance: Dependency1!

      beforeEach {
        instance = subject.create(component)
      }

      it("caches the instance") {
        expect(subject.create(component)) === instance
      }
    }
  }
}