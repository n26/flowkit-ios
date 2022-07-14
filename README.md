# FlowKit
![Swift](https://img.shields.io/badge/Swift-5.x-orange?style=flat-square)
![Platforms](https://img.shields.io/badge/Platforms-iOS_12.x-yellowgreen?style=flat-square)
![CocoaPods](https://img.shields.io/badge/Cocoapods-compatible-red?style=flat-square)
![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
![Coverage](https://img.shields.io/badge/coverage-94.5%25-green?style=flat-square)



FlowKit is a dynamic flow framework capable of building a flow, based on conditions and ordered according to a logic of next steps. By using FlowKit it's possible to create flows for specific users or cases inside your app.
Along with `FlowKit` there is `FlowKitAdditions`, a basic implementation that would allow you to use `FlowKit` directly without coding.

### Features
#### Dynamic flows
An application that uses FlowKit is able to receive the Flow remotely in the form of `JSON` from a Back-end layer, which will contain all the information necessary to generate all possible specific flows and send it to the application. By having all the conditions and the possible flows generation in one single place, it will be easier to test them.
Receiving the flow remotely is only an option: it is possible to save the Flow `JSON` locally in the device and load it as well or create it programmatically in the code.
#### Type safe
The `compiler` will advise you in case that you mix the things. The compiler will be your best friend.
#### Easy to extend
The Step could be easily extended allowing a custom step base object meanwhile the required properties were provided.
#### Non-linear flows
TBD
#### Flow output typed
Define a flow output that FlowKit will use to generate a typed output with autocompletion support(while you are developing)
#### Steps
TBD
## How to use it
### 1. Define your flow
Define your flow using `FlowDefinition`
```swift
struct YourFlowDefinition: FlowDefinition {
    typealias OUTPUT = YourFlowOutput
    typealias STEP = YourStepImplementation
}
```
where `OUTPUT` is your flow output type and `STEP` is your step implementation (You could use the one provided in `FlowKitAdditions`)

### 2. Create your steps
A stepHandler is in charge of handling the step and notify with the completion that the step is done and the flow should go on.
If your step is a screen you should place the logic to present it there.

First you have to define your step, so create a struct that conforms to `StepHandlerDefinition`. It will force you to define the content, the step output and the flow output.
```swift
struct YourStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = YourContent
    typealias STEP_OUTPUT = YourStepOutput
    typealias FLOW_OUTPUT = YourFlowOutputDefinition
    typealias STEP = YourStepImplementation
    static let registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>?
}
```

- The FLOW_OUTPUT and STEP have to be the same type that in the [flow definition](https://github.com/n26/flowkit-ios#Define-your-flow).
- The STEP_OUTPUT is the output of your step, use `StepOutputEmpty` in case that your step doesn't have output.
- The CONTENT is the dynamic content of the step where you should place all the specific data that your step needs to be performed. For example the url of an image if you would like to fetch remotely.

If your step has defined an output that you would like to set in `YourFlowOutputDefinition` you have to specify it.
```swift
static let registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = \YourFlowOutputDefinition.yourProperty
```

Then you can create your step handler with the following sugar syntax:
- Your step has an output
```swift
StepHandler<YourStepHandlerDefinition>.create { _, _, _, _, _ in }
```

- Your step doesn't have an output
```swift
StepHandler<YourStepHandlerDefinition>.createWithEmptyOutput { _, _, _, _, _ in }
```
It would allow you to complete the step with a completion without type, `completion()`

### 3. Implement your step factory
The step factory is in charge of creating the concrete step handler for each step. The OUTPUT and STEP have to be the same that type in the [flow definition](https://github.com/n26/flowkit-ios#Define-your-flow).
```swift
struct YourFactory: StepFactory {
    typealias OUTPUT = YourFlowOutput
    typealias STEP = YourStepInfo

    func makeHandler(for stepInfo: StepInfo) -> AnyStepHandler<OUTPUT, STEP>? {
        //Your steps
        if stepInfo.type == "your step type" {
            return AnyStepHandler(createYourStepHandler())
        }
        
        return nil
    }
    
    func createYourStepHandler() -> StepHandler<YourStepHandlerDefinition> {
        .create { stepInfo, content, navigation, output, completion in
            // Your concrete step code
        }
    }
}
```
### 4. Create your flow
Provide a flow data object, creating it programmatically or getting it from your backend.
```swift
let flowData = FlowData<YourStep>(id: "idFlow", initialStepId: "stepId1", stepsInfo: [YourStepInfo])
```

Create the flow:
```swift
let flow = FlowKit<YourFlowDefinition>(flowData: flowData, featureStepFactory: YourFactory())
```

Wherever you want to start the flow you have to call the method `start`

```swift
flow.start(
    on: navigationController,
    onFinish: { flowOutput in
        //You have the output of the whole flow.
        //Add here you stuff.
    }
)
```

### 5. How to use the flow output typed

To use the typed output you have to provide a struct that conforms to `FlowOutputDefinition`.
```swift
struct ConcreteFlowOutput: FlowOutputDefinition {
    let name: String
    let birthday: Date
    let address: Address
}
```

Then you will be able to use it in your steps and in your flow output with sugar syntax

```swift
StepHandler<YourStepHandlerDefinition>.create { _, _, controller, output, closure in
    print(output.name)
    print(output.address?.city)
    //Add your stuff here
}

// Flow output
flow.start(
    on: navigationController,
    onFinish: { flowOutput in
        //You have the output of the whole flow.
        flowOutput.name
        //Add here you stuff.
    }
)
```

But before you could use it with value, a previous step should set the value
```swift
//Define your step
struct YourStepHandlerDefinition: StepHandlerDefinition {
    typealias CONTENT = YourContent
    typealias STEP_OUTPUT = YourStepOutput
    typealias FLOW_OUTPUT = YourFlowOutputDefinition
    typealias STEP = YourStep
    static let registerOutputKeyPath: KeyPath<FLOW_OUTPUT, STEP_OUTPUT>? = \YourFlowOutputDefinition.yourProperty
}

StepHandler<YourStepHandlerDefinition>.create { _, _, _, _, closure in
    closure(Value)
}
```

In any case, you could always access the previous step or flow output through a dictionary, but remember that you have to know the `stepId` to `unwrap` and `cast` the value.

```swift
// StepHandler
StepHandler<YourStepHandlerDefinition>.create { _, _, controller, output, closure in
    output.rawData["stepId"] as? String
    output.rawData["stepId2"] as? Address
    //Add your stuff here
}

// Flow output
flow.start(
    on: navigationController,
    onFinish: { flowOutput in
        //You have the output of the whole flow.
        flowOutput.rawData["stepId"] as? String
        //Add here you stuff.
    }
)
```

## How to install
### CocoaPods
```ruby
pod 'flowkit-ios'
```
### Swift package manager
TBD
## Licence
TBD
## Blog
TBD

## Contributing

Contributions are welcome and appreciated.
Check [CONTRIBUTING](CONTRIBUTING.md) for information on how to contribute.