//
//  FlowKitAsyncTests.swift
//  FlowKit
//
//  Spike coverage for the additive async/await API. Proves:
//   1. async `start` drives async-authored step handlers end to end,
//   2. async `start` also drives the EXISTING completion-based handlers unchanged
//      (the adapter is transparent to legacy factories),
//   3. empty-output async handlers complete and contribute no output.
//
//  The pre-existing completion-based suite (FlowKitTests, StepHandlerSpecs, …) is
//  intentionally left untouched and must keep passing — that is the whole point of
//  the additive approach.
//

@testable import FlowKit
import UIKit
import XCTest

private struct AsyncFlowDefinitionMock: FlowDefinition {
    typealias OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = StepMock
}

@available(iOS 13.0, *)
private final class AsyncTestStepFactory: StepFactory {
    typealias OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = StepMock

    let output: String

    init(output: String = "") {
        self.output = output
    }

    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        switch stepRawType {
        case "asyncTest":
            let handler: StepHandler<StringStepHandlerDefinition> = .create { _, _, _, _ in
                // Simulates async work a real step does (network / awaited UI result).
                await Task.yield()
                return self.output
            }
            return AnyStepHandler(handler)
        case "asyncEmpty":
            let handler: StepHandler<TestStepHandlerEmptyOutputDefinition<StepEmptyContentInput>> = .createWithEmptyOutput { _, _, _, _ in
                await Task.yield()
            }
            return AnyStepHandler(handler)
        default:
            return nil
        }
    }
}

@available(iOS 13.0, *)
@MainActor
final class FlowKitAsyncTests: XCTestCase {
    private func makeSteps(count: Int, type: String) -> [StepMock] {
        (1...count).map { idx in
            try! StepMock(
                id: "test\(idx)",
                type: type,
                nextSteps: idx == count ? nil : [
                    NextStep<StepMock.NextStepConditionMock>(nextStepId: "test\(idx + 1)", conditions: nil)
                ],
                content: [:],
                displayConditions: nil
            )
        }
    }

    func test_asyncStart_withAsyncHandlers_returnsOutput() async throws {
        let flowData = FlowData<StepMock>(id: "test", initialStepId: "test1", stepsInfo: makeSteps(count: 5, type: "asyncTest"))
        let flow = FlowKit<AsyncFlowDefinitionMock>(flowData: flowData, featureStepFactory: AsyncTestStepFactory(output: "output"))

        let output = try await flow.start(on: UINavigationController())

        XCTAssertEqual(output.rawData.count, 5)
        (1...5).forEach { idx in
            XCTAssertEqual(output.rawData["test\(idx)"] as? String, "output")
        }
    }

    func test_asyncStart_overLegacyCompletionHandlers_returnsOutput() async throws {
        let flowData = FlowData<StepMock>(id: "test", initialStepId: "test1", stepsInfo: makeSteps(count: 5, type: "test"))
        // TestStepFactory authors its handlers with the *completion-based* `.create`.
        let flow = FlowKit<AsyncFlowDefinitionMock>(flowData: flowData, featureStepFactory: TestStepFactory(output: "output"))

        let output = try await flow.start(on: UINavigationController())

        XCTAssertEqual(output.rawData.count, 5)
        (1...5).forEach { idx in
            XCTAssertEqual(output.rawData["test\(idx)"] as? String, "output")
        }
    }

    func test_asyncStart_withEmptyOutputHandler_producesNoOutput() async throws {
        let flowData = FlowData<StepMock>(id: "test", initialStepId: "test1", stepsInfo: makeSteps(count: 1, type: "asyncEmpty"))
        let flow = FlowKit<AsyncFlowDefinitionMock>(flowData: flowData, featureStepFactory: AsyncTestStepFactory())

        let output = try await flow.start(on: UINavigationController())

        XCTAssertEqual(output.rawData.count, 0)
    }

    func test_asyncStart_whenStepHandlerMissing_throwsFlowError() async {
        // No handler is registered for "unknownType", so the engine fails its
        // integrity check; the async start must rethrow it (the completion API
        // would instead route it to `onErrorHandler`).
        let flowData = FlowData<StepMock>(id: "test", initialStepId: "test1", stepsInfo: makeSteps(count: 1, type: "unknownType"))
        let flow = FlowKit<AsyncFlowDefinitionMock>(flowData: flowData, featureStepFactory: AsyncTestStepFactory())

        do {
            _ = try await flow.start(on: UINavigationController())
            XCTFail("Expected start(on:) to throw a FlowError")
        } catch let error as FlowKit<AsyncFlowDefinitionMock>.FlowError {
            guard case .cannotCreateStepHandler = error else {
                return XCTFail("Unexpected FlowError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
