@testable import Drip

import Quick
import Nimble

class SingleSpec: QuickSpec {
  override func spec() {
    var subject: Single<DependencyB, ComponentB>!
    var component: ComponentB!

    beforeEach {
      subject = Single { _ in return DependencyB() }
      component = ComponentB()
    }

    describe("create") {
      var instance: DependencyB!

      beforeEach {
        instance = subject.create(component)
      }

      it("caches the instance") {
        expect(subject.create(component)) === instance
      }
    }
  }
}