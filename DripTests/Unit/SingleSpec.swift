@testable import Drip

import Quick
import Nimble

class SingleSpec: QuickSpec {
  override func spec() {
    var subject: Single<Dependency, TestComponent>!
    var component: TestComponent!

    beforeEach {
      subject = Single { _ in return Dependency() }
      component = TestComponent()
    }

    describe("create") {
      var instance: Dependency!

      beforeEach {
        instance = subject.create(component)
      }

      it("caches the instance") {
        expect(subject.create(component)) === instance
      }
    }
  }
}