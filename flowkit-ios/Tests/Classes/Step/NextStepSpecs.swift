//
// Created by Alex Martinez on 15/10/2020.
//

@testable import N26FlowKitCore
import Nimble
import Quick

final class NextStepSpecs: QuickSpec {
    override func spec() {
        describe("NextStep") {
            context("decode json only with mandatory fields") {
                let json: [String: Any] = [
                    "nextStepId": "stepId"
                ]

                let sut: NextStep<StepMock.NextStepConditionMock>? = try? decode(json)

                it("should have a correct nextStepId") {
                    expect(sut?.nextStepId).to(equal("stepId"))
                }

                it("should not have conditions") {
                    expect(sut?.conditions).to(beNil())
                }
            }
        }
    }
}
