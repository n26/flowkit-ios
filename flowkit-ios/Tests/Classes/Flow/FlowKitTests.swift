//
// Created by Giulio Lombardo  on 13/01/22.
//

@testable import FlowKit
import XCTest

final class FlowKitTests: XCTestCase {
    func test_flowKit_complete_withCorrectOutput() {
        let stepsInfo = (1...5).map({ idx in
            try! StepMock(
                id: "test" + idx.description,
                type: "test",
                nextSteps: idx == 5 ? nil : [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test" + (idx + 1).description,
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            )
        })
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 5)
        
        (1...5).forEach({ idx in
            XCTAssertEqual(output?["test" + idx.description] as? String, "output")
        })
    }
    
    func test_flowKit_complete_withCorrectOutput_rightOrder() {
        let stepsInfo = (1...5).map({ idx in
            try! StepMock(
                id: "test" + idx.description,
                type: "testOrder",
                nextSteps: idx == 5 ? nil : [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test" + (idx + 1).description,
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            )
        })
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output_#")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 5)
        
        (1...5).forEach({ idx in
            XCTAssertEqual(output?["test" + idx.description] as? String, "output_#" + idx.description)
        })
    }
    
    func test_flowKit_complete_withCorrectOutput_differentOutputs() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "testEmptyOutput",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "testEmptyOutput",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 1)
        XCTAssertEqual(output?.first?.value as? String, "output")
    }
    
    func test_flowKit_flowOutputData_withVariousTypes() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "testEmptyOutput",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "testWithContainerKeyOne",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "testWithContainerAnotherKey",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test4",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test4",
                type: "testEmptyOutput",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test5",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test5",
                type: "testContainerOutput",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestFlowDefinitionStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 3)
        
        XCTAssertEqual(output?["test2"] as? String, "output")
        XCTAssertEqual(output?["test3"] as? String, "output")
        XCTAssertEqual(output?["test5"] as? String, "text:output - message:output")
    }
    
    func test_flowKit_flowOutputData_withUnknownTypes() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "testEmptyOutput",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "testWithContainerKeyOne",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "testWithContainerAnotherKey",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test4",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test4",
                type: "testEmptyOutput",
                nextSteps: [
                    NextStep(
                        nextStepId: "test5",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test5",
                type: "testContainerOutputNotUsed",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestFlowDefinitionStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 2)
        
        XCTAssertEqual(output?["test2"] as? String, "output")
        XCTAssertEqual(output?["test3"] as? String, "output")
    }
    
    func test_flowKit_flowOutputData_typedOutput() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "testEmptyOutput",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "testWithContainerKeyOne",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "testWithContainerAnotherKey",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test4",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test4",
                type: "testEmptyOutput",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test5",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test5",
                type: "testEmptyOutput",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestFlowDefinitionStepFactoryMock(output: "output")
        )
        
        var output: FlowOutput<FlowOutputDefinitionMock>?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput
            }
        )
        
        XCTAssertEqual(output?.text, "output")
        XCTAssertEqual(output?.anotherText, "output")
        XCTAssertNil(output?.notUsedType)
    }
    
    func test_flowKit_flowID() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )
        
        var flowID: String?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                flowID = flowOutput.flowId
            }
        )
        
        XCTAssertEqual(flowID, "test")
    }
    
    func test_flowKit_withShouldBeDisplayed() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "testShouldNotBeDisplayed",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 2)
        
        XCTAssertEqual(output?["test1"] as? String, "output")
        XCTAssertEqual(output?["test3"] as? String, "output")
    }
    
    func test_flowKit_errorFlow() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test3",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertNil(output)
    }
    
    func test_flowKit_nextStep_withMultipleMatching() {
        let test1StepInfo = try! StepMock(
            id: "test1",
            type: "test",
            nextSteps: [
                NextStep(
                    nextStepId: "test2",
                    conditions: [
                        StepMock.NextStepConditionMock(shouldMatch: true)
                    ]
                ),
                NextStep(
                    nextStepId: "test3",
                    conditions: [
                        StepMock.NextStepConditionMock(shouldMatch: true)
                    ]
                )
            ],
            content: [:],
            displayConditions: nil
        )
        let stepsInfo = [
            test1StepInfo,
            try! StepMock(
                id: "test2",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )
        
        let navigationController = UINavigationControllerMock()
        var viewControllerPushed: Bool = false
        
        navigationController.pushCompletion = {
            viewControllerPushed.toggle()
        }
        
        var expectedError: FlowKit<FlowEmptyOutputDefinitionMock>.FlowError?
        var expectedNavigation: UINavigationController?
        flow.start(
            on: navigationController,
            onErrorHandler: { error, navigation in
                expectedError = error
                expectedNavigation = navigation
            },
            onFinish: { _ in }
        )
        
        XCTAssertFalse(viewControllerPushed)
        XCTAssertNotNil(expectedError)

        guard let expectedError = expectedError, case FlowKit<FlowEmptyOutputDefinitionMock>.FlowError.multipleMatchingConditions(let stepInfo) = expectedError else {
            XCTFail("Error must be multipleMatchingConditions error")
            return
        }
        XCTAssertEqual(stepInfo, test1StepInfo)
        XCTAssertEqual(navigationController, expectedNavigation)
    }
    
    func test_flowKit_nextStep_withMultipleDefaultPath() {
        let test1StepInfo = try! StepMock(
            id: "test1",
            type: "test",
            nextSteps: [
                NextStep<StepMock.NextStepConditionMock>(
                    nextStepId: "test2",
                    conditions: nil
                ),
                NextStep<StepMock.NextStepConditionMock>(
                    nextStepId: "test3",
                    conditions: nil
                )
            ],
            content: [:],
            displayConditions: nil
        )

        let stepsInfo = [
            test1StepInfo,
            try! StepMock(
                id: "test2",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )
        
        let navigationController = UINavigationControllerMock()
        var viewControllerPushed: Bool = false
        
        navigationController.pushCompletion = {
            viewControllerPushed.toggle()
        }
        
        var expectedError: FlowKit<FlowEmptyOutputDefinitionMock>.FlowError?

        flow.start(
            on: navigationController,
            onErrorHandler: { error, _ in
                expectedError = error
            },
            onFinish: { _ in }
        )
        
        XCTAssertFalse(viewControllerPushed)
        XCTAssertNotNil(expectedError)

        guard let expectedError = expectedError, case FlowKit<FlowEmptyOutputDefinitionMock>.FlowError.multipleMatchingConditions(let stepInfo) = expectedError else {
            XCTFail("Error must be multipleMatchingConditions error")
            return
        }
        XCTAssertEqual(stepInfo, test1StepInfo)
    }
    
    func test_flowKit_nextStep_returnsDefaultPathStepID() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    ),
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: [
                            StepMock.NextStepConditionMock(shouldMatch: false)
                        ]
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?["test1"] as? String, "output")
        XCTAssertEqual(output?["test2"] as? String, "output")
        XCTAssertEqual(output?["test3"] as? String, "output")
    }
    
    func test_flowKit_nextStep_withMatchingConditions() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    ),
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: [
                            StepMock.NextStepConditionMock(shouldMatch: true)
                        ]
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 2)
        
        XCTAssertEqual(output?["test1"] as? String, "output")
        XCTAssertEqual(output?["test3"] as? String, "output")
    }
    
    func test_flowKit_nextStep_withMatchingConditions_noResult() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: [
                            StepMock.NextStepConditionMock()
                        ]
                    ),
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: [
                            StepMock.NextStepConditionMock()
                        ]
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test2",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test3",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test3",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )
        
        var output: [String: Any]?
        
        flow.start(
            on: UINavigationController(),
            onFinish: { flowOutput in
                output = flowOutput.rawData
            }
        )
        
        XCTAssertEqual(output?.count, 1)
        
        XCTAssertEqual(output?["test1"] as? String, "output")
    }
    
    func test_flowKit_willPerformStepCalled() {
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )
        
        var willPerformStepCalled: Bool = false
        
        flow.start(
            on: UINavigationController(),
            willPerformStep: { _ in
                willPerformStepCalled.toggle()
            },
            onFinish: { _ in }
        )
        
        XCTAssertTrue(willPerformStepCalled)
    }
    
    func test_flowKit_willPerformStepCalled_withCorrectSteps() {
        let step = try! StepMock(
            id: "test1",
            type: "test",
            nextSteps: nil,
            content: [:],
            displayConditions: nil
        )
        
        let stepsInfo = [
            step
        ]
        
        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )
        
        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )
        
        var stepResult: StepMock?
        
        flow.start(
            on: UINavigationController(),
            willPerformStep: { step in
                stepResult = step
            },
            onFinish: { _ in }
        )

        XCTAssertEqual(stepResult, step)
    }

    // MARK: - Error handling
    func test_flowKit_onErrorHandlerCalled_withCannotCreateFlowError() {
        let step = try! StepMock(
            id: "test1",
            type: "test",
            nextSteps: nil,
            content: [:],
            displayConditions: nil
        )

        let stepsInfo = [
            step
        ]

        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "unknownStepId",
            stepsInfo: stepsInfo
        )

        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )

        var expectedError: FlowKit<FlowEmptyOutputDefinitionMock>.FlowError?
        var expectedNavigation: UINavigationController?
        let navigation = UINavigationController()
        flow.start(
            on: navigation,
            onErrorHandler: { error, navigation in
                expectedError = error
                expectedNavigation = navigation
            },
            onFinish: { _ in }
        )

        guard case let .cannotCreateFlow(stepError) = expectedError else {
            XCTFail("flowKitError must be cannotCreateFlow")
            return
        }

        XCTAssertEqual(navigation, expectedNavigation)
        XCTAssertEqual(stepError, .initialStepNotFound(stepId: "unknownStepId"))
    }

    func test_flowKit_onErrorHandlerCalled_withCannotCreateStepHandlerError() {
        let step = try! StepMock(
            id: "test1",
            type: "test1",
            nextSteps: nil,
            content: [:],
            displayConditions: nil
        )

        let stepsInfo = [
            step
        ]

        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )

        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )

        var expectedError: FlowKit<FlowEmptyOutputDefinitionMock>.FlowError?
        var expectedNavigation: UINavigationController?
        let navigation = UINavigationController()
        flow.start(
            on: navigation,
            onErrorHandler: { error, navigation in
                expectedError = error
                expectedNavigation = navigation
            },
            onFinish: { _ in }
        )

        guard case let .cannotCreateStepHandler(stepInfo) = expectedError else {
            XCTFail("flowKitError must be cannotCreateFlow")
            return
        }

        XCTAssertEqual(navigation, expectedNavigation)
        XCTAssertEqual(stepInfo, step)
    }

    func test_flowKit_onErrorHandlerCalled_withStepContentNotDecodableError() {
        let step = try! StepMock(
            id: "testContent",
            type: "testContent",
            nextSteps: nil,
            content: [:],
            displayConditions: nil
        )

        let stepsInfo = [
            step
        ]

        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "testContent",
            stepsInfo: stepsInfo
        )

        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock()
        )

        var expectedError: FlowKit<FlowEmptyOutputDefinitionMock>.FlowError?
        var expectedNavigation: UINavigationController?
        let navigation = UINavigationController()
        flow.start(
            on: navigation,
            onErrorHandler: { error, navigation in
                expectedError = error
                expectedNavigation = navigation
            },
            onFinish: { _ in }
        )

        guard case let .stepContentNotDecodable(stepInfo) = expectedError else {
            XCTFail("flowKitError must be cannotCreateFlow")
            return
        }

        XCTAssertEqual(navigation, expectedNavigation)
        XCTAssertEqual(stepInfo, step)
    }

    func test_flowKit_whenShouldNotDisplayStepAndNextStepMultipleMatchingConditions_onErrorHandlerCalled_withMultipleMatchingConditionsError() {
        let multipleMatchingConditionsStep = try! StepMock(
            id: "test2",
            type: "testShouldNotBeDisplayed",
            nextSteps: [
                NextStep<StepMock.NextStepConditionMock>(
                    nextStepId: "test3",
                    conditions: [
                        StepMock.NextStepConditionMock(shouldMatch: true)
                    ]
                ),
                NextStep<StepMock.NextStepConditionMock>(
                    nextStepId: "test4",
                    conditions: [
                        StepMock.NextStepConditionMock(shouldMatch: true)
                    ]
                )
            ],
            content: [:],
            displayConditions: nil
        )
        let stepsInfo = [
            try! StepMock(
                id: "test1",
                type: "test",
                nextSteps: [
                    NextStep<StepMock.NextStepConditionMock>(
                        nextStepId: "test2",
                        conditions: nil
                    )
                ],
                content: [:],
                displayConditions: nil
            ),
            multipleMatchingConditionsStep,
            try! StepMock(
                id: "test3",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            ),
            try! StepMock(
                id: "test4",
                type: "test",
                nextSteps: nil,
                content: [:],
                displayConditions: nil
            )
        ]

        let flowData = FlowData<StepMock>(
            id: "test",
            initialStepId: "test1",
            stepsInfo: stepsInfo
        )

        let flow = FlowKit<FlowEmptyOutputDefinitionMock>(
            flowData: flowData,
            featureStepFactory: TestStepFactoryMock(output: "output")
        )

        var expectedError: FlowKit<FlowEmptyOutputDefinitionMock>.FlowError?
        var expectedNavigation: UINavigationController?
        let navigationController = UINavigationController()
        flow.start(
            on: navigationController,
            onErrorHandler: { error, navigation in
                expectedError = error
                expectedNavigation = navigation
            },
            onFinish: { _ in }
        )

        XCTAssertNotNil(expectedError)

        guard case .multipleMatchingConditions(let stepInfo) = expectedError else {
            XCTFail("Error must be multipleMatchingConditions error")
            return
        }
        XCTAssertEqual(stepInfo, multipleMatchingConditionsStep)
        XCTAssertEqual(navigationController, expectedNavigation)
    }
}

struct FlowOutputDefinitionMock: FlowOutputDefinition {
    let testContainerOutput: String
    let testContainerOutputNotUsed: String
    let text: String
    let anotherText: String
    let notUsedType: String
}

struct FlowOutputEmptyDefinitionMock: FlowOutputDefinition {}

private class FlowDefinitionMock: FlowDefinition {
    typealias OUTPUT = FlowOutputDefinitionMock
    typealias STEP = StepMock
}

private class FlowEmptyOutputDefinitionMock: FlowDefinition {
    typealias OUTPUT = FlowOutputEmptyDefinitionMock
    typealias STEP = StepMock
}

private class TestStepFactoryMock: StepFactory {
    struct StringStepHandlerDefinition: StepHandlerDefinition {
        typealias CONTENT = StepEmptyContentInput
        typealias STEP_OUTPUT = String
        typealias FLOW_OUTPUT = FlowOutputEmptyDefinitionMock
        typealias STEP = StepMock
        
        static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>?
    }
    
    struct EmptyOutputStepHandlerDefinition<STEP_CONTENT: Decodable>: StepHandlerDefinition {
        typealias CONTENT = StepEmptyContentInput
        typealias STEP_OUTPUT = StepOutputEmpty
        typealias FLOW_OUTPUT = FlowOutputEmptyDefinitionMock
        typealias STEP = StepMock
    }

    struct TestContentStepHandlerDefinition: StepHandlerDefinition {
        typealias CONTENT = TestContent
        typealias STEP_OUTPUT = StepOutputEmpty
        typealias FLOW_OUTPUT = FlowOutputEmptyDefinitionMock
        typealias STEP = StepMock
    }

    struct TestContent: Decodable {
        let title: String
        let description: String
    }

    enum StepsType: String, RawRepresentable {
        case test
        case testOrder
        case testEmptyOutput
        case testShouldNotBeDisplayed
        case testContent
    }
    
    typealias OUTPUT = FlowOutputEmptyDefinitionMock
    typealias STEP = StepMock
    
    private let output: String
    private var order: Int = 0
    
    init(output: String = "") {
        self.output = output
    }
    
    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        guard let stepType = StepsType(rawValue: stepRawType) else {
            return nil
        }
        
        switch stepType {
        case .test:
            let handler: StepHandler<StringStepHandlerDefinition> = .create { _, _, _, _, closure in
                closure(self.output)
            }
            
            return AnyStepHandler(handler)
            
        case .testOrder:
            let handler: StepHandler<StringStepHandlerDefinition> = .create { _, _, _, _, closure in
                self.order += 1
                
                closure(self.output + self.order.description)
            }
            
            return AnyStepHandler(handler)
            
        case .testEmptyOutput:
            let handler: StepHandler<EmptyOutputStepHandlerDefinition<StepEmptyContentInput>> = .createWithEmptyOutput { _, _, _, _, closure in
                closure()
            }
            
            return AnyStepHandler(handler)
            
        case .testShouldNotBeDisplayed:
            let handler: StepHandler<StringStepHandlerDefinition> = .create(shouldBeDisplayed: { _, _, _ in
                false
            }, perform: { _, _, _, _, closure in
                closure(self.output)
            })
            
            return AnyStepHandler(handler)
        case .testContent:
            let handler: StepHandler<TestContentStepHandlerDefinition> = .create { _, _, _, _, _ in }
            return AnyStepHandler(handler)
        }
    }
}

private class TestFlowDefinitionStepFactoryMock: StepFactory {
    struct EmptyStepHandlerDefinition: StepHandlerDefinition {
        typealias CONTENT = StepEmptyContentInput
        typealias STEP_OUTPUT = StepOutputEmpty
        typealias FLOW_OUTPUT = FlowOutputDefinitionMock
        typealias STEP = StepMock
    }
    
    struct ContainerKeyOneStepHandlerDefinition: StepHandlerDefinition {
        typealias CONTENT = StepEmptyContentInput
        typealias STEP_OUTPUT = String
        typealias FLOW_OUTPUT = FlowOutputDefinitionMock
        typealias STEP = StepMock
        
        static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = \.text
    }
    
    struct ContainerAnotherKeyStepHandlerDefinition: StepHandlerDefinition {
        typealias CONTENT = StepEmptyContentInput
        typealias STEP_OUTPUT = String
        typealias FLOW_OUTPUT = FlowOutputDefinitionMock
        typealias STEP = StepMock
        
        static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = \.anotherText
    }
    
    struct ContainerOutputStepHandlerDefinition: StepHandlerDefinition {
        typealias CONTENT = StepEmptyContentInput
        typealias STEP_OUTPUT = String
        typealias FLOW_OUTPUT = FlowOutputDefinitionMock
        typealias STEP = StepMock
        
        static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = \.testContainerOutput
    }
    
    struct ContainerOutputNotUsedStepHandlerDefinition: StepHandlerDefinition {
        typealias CONTENT = StepEmptyContentInput
        typealias STEP_OUTPUT = String
        typealias FLOW_OUTPUT = FlowOutputDefinitionMock
        typealias STEP = StepMock
        
        static var registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = \.testContainerOutputNotUsed
    }
    
    typealias OUTPUT = FlowOutputDefinitionMock
    typealias STEP = StepMock
    
    enum StepsType: String, RawRepresentable {
        case testEmptyOutput
        case testWithContainerKeyOne
        case testWithContainerAnotherKey
        case testContainerOutput
        case testContainerOutputNotUsed
    }
    
    private let output: String
    
    init(output: String = "") {
        self.output = output
    }
    
    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        guard let stepType = StepsType(rawValue: stepRawType) else {
            return nil
        }
        
        switch stepType {
        case .testEmptyOutput:
            let handler: StepHandler<EmptyStepHandlerDefinition> = .createWithEmptyOutput { _, _, _, _, closure in
                closure()
            }
            
            return AnyStepHandler(handler)
            
        case .testWithContainerKeyOne:
            let handler: StepHandler<ContainerKeyOneStepHandlerDefinition> = .create { _, _, _, _, closure in
                closure(self.output)
            }
            
            return AnyStepHandler(handler)
            
        case .testWithContainerAnotherKey:
            let handler: StepHandler<ContainerAnotherKeyStepHandlerDefinition> = .create { _, _, _, _, closure in
                closure(self.output)
            }
            
            return AnyStepHandler(handler)
            
        case .testContainerOutput:
            let handler: StepHandler<ContainerOutputStepHandlerDefinition> = .create { _, _, _, output, closure in
                closure("text:" + output.text! + " - message:" + output.anotherText!)
            }
            
            return AnyStepHandler(handler)
            
        case .testContainerOutputNotUsed:
            let handler: StepHandler<ContainerOutputNotUsedStepHandlerDefinition> = .create { _, _, _, output, closure in
                closure(output.notUsedType)
            }
            
            return AnyStepHandler(handler)
        }
    }
}

private class UINavigationControllerMock: UINavigationController {
    var pushCompletion: (() -> Void)?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.viewDidLoad()
        pushCompletion?()
    }
}
