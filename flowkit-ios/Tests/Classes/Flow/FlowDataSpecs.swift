//
// Created by Alex Martinez on 25/05/2020.
//

@testable import FlowKit
import Nimble
import Quick

final class FlowDataSpecs: QuickSpec {
    override func spec() {
        describe("FlowData") {
            context("Decoding a JSON") {
                context("main properties") {
                    let json: [String: Any] = [
                        "id": "FLOW_ID",
                        "initialStepId": "occupation",
                        "steps": []
                    ]

                    let sut: FlowData<StepMock>? = try? decode(json)

                    it("should have the correct id") {
                        expect(sut?.id).to(equal("FLOW_ID"))
                    }

                    it("should have the correct initial step") {
                        expect(sut?.initialStepId).to(equal("occupation"))
                    }
                }

                context("JSON without steps") {
                    let json: [String: Any] = [
                        "id": "FLOW_ID",
                        "initialStepId": "occupation",
                        "steps": []
                    ]

                    let sut: FlowData<StepMock>? = try? decode(json)

                    it("should have an empty array") { 
                        expect(sut?.stepsInfo.isEmpty).to(beTrue())
                    }
                }

                context("JSON with multiple steps") {
                    let json: [String: Any] = [
                        "id": "FLOW_ID",
                        "initialStepId": "occupation",
                        "steps": [
                            [
                                "id": "step1",
                                "type": "empty_content",
                                "nextStep": "step2",
                                "content": [:]
                            ],
                            [
                                "id": "step2",
                                "type": "DATE_INPUT",
                                "nextStep": "step3",
                                "content": [
                                    "title": "When was your business founded?",
                                    "description": "This is the day you became self-employed.",
                                    "minDate": "1974-10-19",
                                    "maxDate": "2019-04-18"
                                ]
                            ],
                            [
                                "id": "step3",
                                "type": "DATE_INPUT",
                                "nextStep": "employmentStartDate",
                                "content": [
                                    "title": "When was your business founded?",
                                    "description": "This is the day you became self-employed.",
                                    "minDate": "1974-10-19",
                                    "maxDate": "2019-04-18"
                                ]
                            ]
                        ]
                    ]

                    let sut: FlowData<StepMock>? = try? decode(json)

                    it("should have correct num steps") {
                        expect(sut?.stepsInfo.count).to(equal(3))
                    }

                    it("should have step info for the step 1") {
                        expect(sut?.stepsInfo[0].id).to(equal("step1"))
                        expect(sut?.stepsInfo[0].type).to(equal("empty_content"))
                        expect(sut?.stepsInfo[0].contentDecoder).toNot(beNil())
                    }

                    it("should have step info for the step 2") {
                        expect(sut?.stepsInfo[1].id).to(equal("step2"))
                        expect(sut?.stepsInfo[1].type).to(equal("DATE_INPUT"))
                        expect(sut?.stepsInfo[1].contentDecoder).toNot(beNil())
                    }

                    it("should have step info for the step 3") {
                        expect(sut?.stepsInfo[2].id).to(equal("step3"))
                        expect(sut?.stepsInfo[2].type).to(equal("DATE_INPUT"))
                        expect(sut?.stepsInfo[2].contentDecoder).toNot(beNil())
                    }
                }

                context("non linear flows backwards compatibility") {
                    let json: [String: Any] = [
                        "id": "FLOW_ID",
                        "initialStepId": "occupation",
                        "steps": [
                            [
                                "id": "step1",
                                "type": "empty_content",
                                "nextStep": "step2",
                                "content": [:]
                            ],
                            [
                                "id": "step2",
                                "type": "empty_content",
                                "nextStep": "step3",
                                "content": [:]
                            ],
                            [
                                "id": "step3",
                                "type": "empty_content",
                                "nextStep": "step4",
                                "content": [:]
                            ],
                            [
                                "id": "step4",
                                "type": "empty_content",
                                "content": [:]
                            ]
                        ]
                    ]

                    let sut: FlowData<StepMock>? = try? decode(json)

                    it("should have nextSteps with nextStep value") {
                        expect(sut?.stepsInfo[0].nextSteps).to(equal([NextStep(nextStepId: "step2", conditions: nil)]))
                        expect(sut?.stepsInfo[1].nextSteps).to(equal([NextStep(nextStepId: "step3", conditions: nil)]))
                        expect(sut?.stepsInfo[2].nextSteps).to(equal([NextStep(nextStepId: "step4", conditions: nil)]))
                        expect(sut?.stepsInfo[3].nextSteps).to(beNil())
                    }
                }
            }
            
            context("appending flows") {
                func step(id: String, next: String?) -> StepMock {
                    try! StepMock(
                        id: id,
                        type: "type\(id)",
                        nextSteps: next.map { [NextStep(nextStepId: $0, conditions: nil)] },
                        content: [:],
                        displayConditions: nil
                    )
                }

                let flow1 = FlowData<StepMock>(
                    id: "flow",
                    initialStepId: "1",
                    stepsInfo: [
                        step(id: "1", next: "2"),
                        step(id: "2", next: "3"),
                        step(id: "3", next: nil)
                    ]
                )
                
                let flow2 = FlowData<StepMock>(
                    id: "flow2",
                    initialStepId: "4",
                    stepsInfo: [
                        step(id: "4", next: "5"),
                        step(id: "5", next: "6"),
                        step(id: "6", next: nil)
                    ]
                )
                
                let result = flow1.appending(flow2)

                it("should have the id of the first flow") {
                    expect(result.id) == "flow"
                }
                
                it("should have the initial stepId of the first flow") {
                    expect(result.initialStepId) == "1"
                }
                
                it("should merge the stepInfos and link the flows") {
                    expect(result.stepsInfo) == [
                        AnyStep(step(id: "1", next: "2")),
                        AnyStep(step(id: "2", next: "3")),
                        AnyStep(step(id: "3", next: "4")),
                        AnyStep(step(id: "4", next: "5")),
                        AnyStep(step(id: "5", next: "6")),
                        AnyStep(step(id: "6", next: nil))
                    ]
                }
            }
        }
    }
}
