//
// Created by Alex Martinez on 22/06/2020.
//

@testable import FlowKit
import Nimble
import Quick

final class FlowOutputSpecs: QuickSpec {
    override func spec() {
        describe("FlowOutput") {
            context("subscript") {
                it("should return nil for unknown type") { 
                    let sut = FlowOutput<TestFlowDefinition>(flowId: "", rawData: ["stepId1": "message"], keyPathMapped: [\TestAnotherFlowDefinition.anotherText: "stepId1"])
                    expect(sut.anotherText).to(beNil())
                }

                it("should return nil for not existing values") {
                    let sut = FlowOutput<TestFlowDefinition>(flowId: "", rawData: [:], keyPathMapped: [\TestFlowDefinition.text: "stepId1"])
                    expect(sut.text).to(beNil())
                }

                it("should return nil for unregistered stepId") {
                    let sut = FlowOutput<TestFlowDefinition>(flowId: "", rawData: ["stepId1": "message"], keyPathMapped: [:])
                    expect(sut.text).to(beNil())
                }

                it("Should return the object for the given type") {
                    let sut = FlowOutput<TestFlowDefinition>(flowId: "", rawData: ["stepId1": "message"], keyPathMapped: [\TestFlowDefinition.anotherText: "stepId1"])
                    expect(sut.anotherText).to(equal("message"))
                }
                
                it("Should return the rawData for the given type") {
                    let sut = FlowOutput<FlowOutputEmptyDefinition>(flowId: "", rawData: ["stepId1": "message"])
                    expect(sut.rawData["stepId1"] as? String).to(equal("message"))
                }

                it("Should return the flowId for the given type") {
                    let sut = FlowOutput<FlowOutputEmptyDefinition>(flowId: "1234", rawData: ["stepId1": "message"])
                    expect(sut.flowId).to(equal("1234"))
                }
            }
        }
    }
}
