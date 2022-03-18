//
// Created by Alex Martinez on 20/05/2020.
//

@testable import N26FlowKitCore
import Nimble
import Quick

final class StepSpecs: QuickSpec {
    override func spec() {
        describe("Step") {
            context("creating a Step") { 
                it("should throw if the initial step id not exists") { 
                    let stepsInfo = [
                        AnyStep<StepMock>(try! StepMock(id: "test1", type: "test", nextSteps: [NextStep(nextStepId: "test2", conditions: nil)], content: [:], displayConditions: nil)),
                        AnyStep<StepMock>(try! StepMock(id: "test2", type: "test", nextSteps: [NextStep(nextStepId: "test3", conditions: nil)], content: [:], displayConditions: nil)),
                        AnyStep<StepMock>(try! StepMock(id: "test3", type: "test", nextSteps: [NextStep(nextStepId: "test4", conditions: nil)], content: [:], displayConditions: nil))
                    ]

                    expect(StepsTree<StepMock>(initialStepId: "unknownStepId", stepsInfo: stepsInfo)).to(equal(StepsTree.error(error: StepError.initialStepNotFound(stepId: "unknownStepId"))))
                }

                it("should throw if a next step id not exists") {
                    let stepInfo1 = AnyStep<StepMock>(try! StepMock(id: "test1", type: "test", nextSteps: [NextStep(nextStepId: "test2", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo2 = AnyStep<StepMock>(try! StepMock(id: "test2", type: "test", nextSteps: [NextStep(nextStepId: "unknownStep", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo3 = AnyStep<StepMock>(try! StepMock(id: "test3", type: "test", nextSteps: [NextStep(nextStepId: "test4", conditions: nil)], content: [:], displayConditions: nil))

                    let stepsInfo = [stepInfo1, stepInfo2, stepInfo3]

                    expect(StepsTree<StepMock>(initialStepId: "test1", stepsInfo: stepsInfo))
                        .to(equal(
                                StepsTree.node(stepInfo: stepInfo1, next: [.error(error: StepError.stepNotFound(stepId: "test2"))]))
                        )
                }

                it("should throw if the flow don't have a final nil nextStep") {
                    let stepInfo1 = AnyStep<StepMock>(try! StepMock(id: "test1", type: "test", nextSteps: [NextStep(nextStepId: "test2", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo2 = AnyStep<StepMock>(try! StepMock(id: "test2", type: "test", nextSteps: [NextStep(nextStepId: "test3", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo3 = AnyStep<StepMock>(try! StepMock(id: "test3", type: "test", nextSteps: [NextStep(nextStepId: "test4", conditions: nil)], content: [:], displayConditions: nil))

                    let stepsInfo = [stepInfo1, stepInfo2, stepInfo3]

                    expect(StepsTree<StepMock>(initialStepId: "test1", stepsInfo: stepsInfo)).to(equal(StepsTree.node(stepInfo: stepInfo1, next: [.node(stepInfo: stepInfo2, next: [.error(error: StepError.stepNotFound(stepId: "test3"))])])))
                }

                it("should throw if the flow has a loop") {
                    let stepInfo1 = AnyStep<StepMock>(try! StepMock(id: "test1", type: "test", nextSteps: [NextStep(nextStepId: "test2", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo2 = AnyStep<StepMock>(try! StepMock(id: "test2", type: "test", nextSteps: [NextStep(nextStepId: "test3", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo3 = AnyStep<StepMock>(try! StepMock(id: "test3", type: "test", nextSteps: [NextStep(nextStepId: "test2", conditions: nil)], content: [:], displayConditions: nil))

                    let stepsInfo = [stepInfo1, stepInfo2, stepInfo3]

                    expect(StepsTree<StepMock>(initialStepId: "test1", stepsInfo: stepsInfo)).to(equal(StepsTree.node(stepInfo: stepInfo1, next: [.node(stepInfo: stepInfo2, next: [.node(stepInfo: stepInfo3, next: [.error(error: StepError.flowMalformed(stepId: "test2"))])])])))
                }

                it("should generate without using all steps") {
                    let stepInfo1 = AnyStep<StepMock>(try! StepMock(id: "test1", type: "test", nextSteps: [NextStep(nextStepId: "test2", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo2 = AnyStep<StepMock>(try! StepMock(id: "test2", type: "test", nextSteps: [NextStep(nextStepId: "test3", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo3 = AnyStep<StepMock>(try! StepMock(id: "test3", type: "test", nextSteps: nil, content: [:], displayConditions: nil))

                    let stepsInfo = [stepInfo1, stepInfo2, stepInfo3]
                    expect(StepsTree(initialStepId: "test2", stepsInfo: stepsInfo)).to(equal(StepsTree.node(stepInfo: stepInfo2, next: [.node(stepInfo: stepInfo3, next: [.none])])))
                }

                it("should generate none step if stepsInfo is empty") {
                    let stepsInfo: [AnyStep<StepMock>] = []
                    expect(StepsTree<StepMock>(initialStepId: "test1", stepsInfo: stepsInfo)).to(equal(StepsTree<StepMock>.none))
                }

                it("should generate the step nodes") {
                    let stepInfo1 = AnyStep<StepMock>(try! StepMock(id: "test1", type: "test", nextSteps: [NextStep(nextStepId: "test2", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo2 = AnyStep<StepMock>(try! StepMock(id: "test2", type: "test", nextSteps: [NextStep(nextStepId: "test3", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo3 = AnyStep<StepMock>(try! StepMock(id: "test3", type: "test", nextSteps: nil, content: [:], displayConditions: nil))

                    let stepsInfo = [stepInfo1, stepInfo2, stepInfo3]
                    expect(StepsTree<StepMock>(initialStepId: "test1", stepsInfo: stepsInfo)).to(equal(StepsTree.node(stepInfo: stepInfo1, next: [.node(stepInfo: stepInfo2, next: [.node(stepInfo: stepInfo3, next: [.none])])])))
                }

                it("should generate one single step node") {
                    let stepInfo1 = AnyStep<StepMock>(try! StepMock(id: "test1", type: "test", nextSteps: nil, content: [:], displayConditions: nil))

                    let stepsInfo = [stepInfo1]
                    expect(StepsTree(initialStepId: "test1", stepsInfo: stepsInfo)).to(equal(StepsTree<StepMock>.node(stepInfo: stepInfo1, next: [.none])))
                }

                it("should have an array of next steps") {
                    let stepInfo1 = AnyStep<StepMock>(try! StepMock(
                        id: "test1",
                        type: "test",
                        nextSteps: [NextStep(nextStepId: "test2", conditions: nil), NextStep(nextStepId: "test3", conditions: nil)],
                        content: [:],
                        displayConditions: nil
                    ))
                    let stepInfo2 = AnyStep<StepMock>(try! StepMock(id: "test2", type: "test", nextSteps: [NextStep(nextStepId: "test3", conditions: nil)], content: [:], displayConditions: nil))
                    let stepInfo3 = AnyStep<StepMock>(try! StepMock(id: "test3", type: "test", nextSteps: nil, content: [:], displayConditions: nil))

                    let stepsInfo = [stepInfo1, stepInfo2, stepInfo3]

                    let sut = StepsTree<StepMock>(initialStepId: "test1", stepsInfo: stepsInfo)

                    expect(sut.nextSteps.count).to(equal(2))
                    expect(sut.stepInfo?.id).to(equal(stepInfo1.id))
                }
            }
        }
    }
}
