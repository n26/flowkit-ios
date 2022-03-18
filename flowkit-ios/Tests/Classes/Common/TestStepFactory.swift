//
// Created by Alex Martinez on 18/05/2020.
//

@testable import N26FlowKitCore

final class TestStepFactory: StepFactory {
    typealias OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = StepMock

    let output: String
    var order: Int = 0

    init(output: String = "") {
        self.output = output
    }

    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        switch stepRawType {
        case "test":
            let handler: StepHandler<StringStepHandlerDefinition> = .create { _, _, _, _, closure in
                closure(self.output)
            }
            return AnyStepHandler(handler)
        case "testOrder":
            let handler: StepHandler<StringStepHandlerDefinition> = .create { _, _, _, _, closure in
                self.order += 1
                closure(self.output + "\(self.order)")
            }
            return AnyStepHandler(handler)
        case "testShouldNotBeDisplayed":
            let handler: StepHandler<StringStepHandlerDefinition> = .create(shouldBeDisplayed: { _, _, _ in
                false
            }, perform: { _, _, _, _, closure in
                closure(self.output)
            })
            return AnyStepHandler(handler)
        case "testEmptyOutput":
            let handler: StepHandler<TestStepHandlerEmptyOutputDefinition<StepEmptyContentInput>> = .createWithEmptyOutput { _, _, _, _, closure in
                closure()
            }
            return AnyStepHandler(handler)
        default:
            return nil
        }
    }
}

final class DefaultTestStepFactory: StepFactory {
    typealias OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = StepMock

    let output: String

    init(output: String = "") {
        self.output = output
    }

    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        switch stepRawType {
        case "defaultStepFactory":
            return AnyStepHandler(StepHandler<StringStepHandlerDefinition> { _, _, _, _, closure in
                closure("defaultStepFactory" + self.output)
            })
        default:
            return nil
        }
    }
}

final class TestFlowDefinitionStepFactory: StepFactory {
    typealias OUTPUT = TestFlowDefinition
    typealias STEP = StepMock

    let output: String

    init(output: String = "") {
        self.output = output
    }

    func makeHandler(for stepRawType: String) -> AnyStepHandler<STEP, OUTPUT>? {
        switch stepRawType {
        case "testWithContainerKeyOne":
            let handler: StepHandler<TestWithContainerKeyOneStepHandlerDefinition> = .create { _, _, _, _, closure in
                closure(self.output)
            }
            return AnyStepHandler(handler)
        case "testWithContainerAnotherKey":
            let handler: StepHandler<TestWithContainerAnotherKeyStepHandlerDefinition> = .create { _, _, _, _, closure in
                closure(self.output)
            }
            return AnyStepHandler(handler)
        case "testEmptyOutput":
            let handler: StepHandler<TestEmptyOutputStepHandlerDefinition> = .createWithEmptyOutput { _, _, _, _, closure in
                closure()
            }
            return AnyStepHandler(handler)
        case "testContainerOutput":
            let handler: StepHandler<TestContainerOutputStepHandlerDefinition> = .create { _, _, _, output, closure in
                closure("text:" + output.text! + " - message:" + output.anotherText!)
            }
            return AnyStepHandler(handler)
        case "testContainerOutputNotUsed":
            let handler: StepHandler<TestContainerOutputNotUsedStepHandlerDefinition> = .create { _, _, _, output, closure in
                closure(output.notUsedType)
            }
            return AnyStepHandler(handler)
        default:
            return nil
        }
    }
}

struct TestFlowDefinition: FlowOutputDefinition {
    let testContainerOutput: String
    let testContainerOutputNotUsed: String
    let text: String
    let anotherText: String
    let notUsedType: String
}

struct TestAnotherFlowDefinition: FlowOutputDefinition {
    let text: String
    let anotherText: String
}

struct StringStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = StepEmptyContentInput
    typealias STEP_OUTPUT = String
    typealias FLOW_OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = StepMock

    static var registerOutputKeyPath: KeyPath<FlowOutputEmptyDefinition, String>?
}

struct TestWithContainerKeyOneStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = StepEmptyContentInput
    typealias STEP_OUTPUT = String
    typealias FLOW_OUTPUT = TestFlowDefinition
    typealias STEP = StepMock

    static var registerOutputKeyPath: KeyPath<TestFlowDefinition, String>? = \.text
}

struct TestWithContainerAnotherKeyStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = StepEmptyContentInput
    typealias STEP_OUTPUT = String
    typealias FLOW_OUTPUT = TestFlowDefinition
    typealias STEP = StepMock

    static var registerOutputKeyPath: KeyPath<TestFlowDefinition, String>? = \.anotherText
}

struct TestContainerOutputStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = StepEmptyContentInput
    typealias STEP_OUTPUT = String
    typealias FLOW_OUTPUT = TestFlowDefinition
    typealias STEP = StepMock

    static var registerOutputKeyPath: KeyPath<TestFlowDefinition, String>? = \.testContainerOutput
}

struct TestEmptyOutputStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = StepEmptyContentInput
    typealias STEP_OUTPUT = StepOutputEmpty
    typealias FLOW_OUTPUT = TestFlowDefinition
    typealias STEP = StepMock
}

struct TestContainerOutputNotUsedStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = StepEmptyContentInput
    typealias STEP_OUTPUT = String
    typealias FLOW_OUTPUT = TestFlowDefinition
    typealias STEP = StepMock

    static var registerOutputKeyPath: KeyPath<TestFlowDefinition, String>? = \.testContainerOutputNotUsed
}

struct TestStepHandlerEmptyOutputDefinition<STEP_CONTENT: Decodable>: StepHandlerDefinition {
    typealias CONTENT = STEP_CONTENT
    typealias STEP_OUTPUT = StepOutputEmpty
    typealias FLOW_OUTPUT = FlowOutputEmptyDefinition
    typealias STEP = StepMock
}
