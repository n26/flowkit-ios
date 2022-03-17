//
// Created by Alex Martinez on 26/05/2020.
//

@testable import N26FlowKitCore
import Nimble
import Quick

final class StepHandlerSpecs: QuickSpec {
    override func spec() {
        describe("StepHandler") {
            context("shouldBeDisplayed") {
                context("should return true") {
                    it("shouldBeDisplayed is nil and display conditions are nil") {
                        let sut: StepHandler<StepHandlerMockDefinition> = .create { _, _, _, _, _ in }

                        let stepInfo = try! StepMock(id: "test1", type: "textInput", nextSteps: nil, content: ["text": "test"], displayConditions: nil)

                        expect(sut.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: stepInfo.displayConditions, currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: [:], keyPathMapped: [:]))).to(beTrue())
                    }

                    it("shouldBeDisplayed is nil and display conditions are empty") {
                        let sut: StepHandler<StepHandlerMockDefinition> = .create { _, _, _, _, _ in }

                        let stepInfo = try! StepMock(id: "test1", type: "textInput", nextSteps: nil, content: ["text": "test"], displayConditions: [])

                        expect(sut.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: stepInfo.displayConditions, currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: [:], keyPathMapped: [:]))).to(beTrue())
                    }

                    it("shouldBeDisplayed is nil and display conditions match") {
                        let sut: StepHandler<StepHandlerMockDefinition> = .create { _, _, _, _, _ in }

                        let displayCondition = StepMock.DisplayConditionMock(shouldMatch: true)

                        let stepInfo = try! StepMock(
                            id: "test1", 
                            type: "textInput", 
                            nextSteps: nil,
                            content: ["text": "test"], 
                            displayConditions: [displayCondition])

                        expect(sut.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: stepInfo.displayConditions, currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: ["stepId": "value1"], keyPathMapped: [:]))).to(beTrue())
                    }

                    it("if the content is not decodable should return the default implementation") {
                        let sut: StepHandler<StepHandlerMockDefinition> = .create(
                            shouldBeDisplayed: { _, _, _ in false },
                            perform: { _, _, _, _, _ in }
                        )

                        let stepInfo = try! StepMock(id: "test1", type: "textInput", nextSteps: nil, content: ["unknown": "test"], displayConditions: nil)

                        expect(sut.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: stepInfo.displayConditions, currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: [:], keyPathMapped: [:]))).to(beTrue())
                    }

                    it("if the method return true") {
                        let sut: StepHandler<StepHandlerMockDefinition> = .create(
                            shouldBeDisplayed: { _, _, _ in true },
                            perform: { _, _, _, _, _ in }
                        )

                        let stepInfo = try! StepMock(id: "test1", type: "textInput", nextSteps: nil, content: ["text": "test"], displayConditions: nil)

                        expect(sut.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: stepInfo.displayConditions, currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: [:], keyPathMapped: [:]))).to(beTrue())
                    }
                }

                context("should return false") {
                    it("if the method return false") {
                        let sut: StepHandler<StepHandlerMockDefinition> = .create(
                            shouldBeDisplayed: { _, _, _ in false },
                            perform: { _, _, _, _, _ in }
                        )

                        let stepInfo = try! StepMock(id: "test1", type: "textInput", nextSteps: nil, content: ["text": "test"], displayConditions: nil)

                        expect(sut.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: stepInfo.displayConditions, currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: [:], keyPathMapped: [:]))).to(beFalse())
                    }

                    it("shouldBeDisplayed is nil and display conditions don't match") {
                        let sut: StepHandler<StepHandlerMockDefinition> = .create { _, _, _, _, _ in }

                        let displayCondition = StepMock.DisplayConditionMock(shouldMatch: false)

                        let stepInfo = try! StepMock(
                            id: "test1",
                            type: "textInput",
                            nextSteps: nil,
                            content: ["text": "test"],
                            displayConditions: [displayCondition])

                        expect(sut.shouldBeDisplayed(contentDecoder: stepInfo.contentDecoder, displayConditions: stepInfo.displayConditions, currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: ["stepId": "valueNotExists"], keyPathMapped: [:]))).to(beFalse())
                    }
                }
            }

            context("perform") {
                it("should perform if content is decoded") {
                    var output: Bool?
                    let sut: StepHandler<StepHandlerMockDefinition> = .create { _, _, _, _, _ in
                        output = true
                    }

                    let stepInfo = try! StepMock(id: "test1", type: "textInput", nextSteps: nil, content: ["text": "test"], displayConditions: nil)
                    try! sut.perform(stepInfo: stepInfo, contentDecoder: stepInfo.contentDecoder, viewController: UINavigationController(), currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: [:], keyPathMapped: [:]), registerOutputType: nil) { _ in }
                    expect(output).to(beTrue())
                }

                it("should throw step content not decodable when step content cannot be decoded") {
                    let sut: StepHandler<StepHandlerMockDefinition> = .create { _, _, _, _, _ in }

                    let stepInfo = try! StepMock(id: "test1", type: "textInput", nextSteps: nil, content: ["unknown": "test"], displayConditions: nil)

                    expect {
                        try sut.perform(stepInfo: stepInfo, contentDecoder: stepInfo.contentDecoder, viewController: UINavigationController(), currentFlowOutput: CurrentFlowOutput(flowId: "", rawData: [:], keyPathMapped: [:]), registerOutputType: nil) { _ in }
                    }
                    .to(throwError(StepHandler<StepHandlerMockDefinition>.StepHandlerError.stepContentNotDecodable(stepInfo: stepInfo)))
                }
            }
        }
    }
}

private struct ContentDecodable: Decodable {
    let text: String
}

private struct StepHandlerMockDefinition: StepHandlerDefinition {
    typealias CONTENT = ContentDecodable
    typealias STEP_OUTPUT = String
    typealias FLOW_OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = StepMock
    static var registerOutputKeyPath: KeyPath<FlowOutputEmptyDefinition, String>?
}
