@testable import Drip

import Quick
import Nimble

class TransientSpec: QuickSpec {
  override func  spec() {
    var subject: Transient<DependencyB, ComponentB>!
    var component: ComponentB!

    beforeEach {
      subject = Transient { _ in return DependencyB() }
      component = ComponentB()
    }

    describe("create") {
      var instance: DependencyB!

      beforeEach {
        instance = subject.create(component)
      }

      it("returns a new instance") {
        expect(subject.create(component)) !== instance
      }
    }
  }
}