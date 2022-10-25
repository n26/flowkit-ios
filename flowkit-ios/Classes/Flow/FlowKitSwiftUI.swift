//
//  Created by Guillem on 2/9/22.
//

import SwiftUI

///
/// FlowKitSwiftUIView struct
/// - Generics
///     - FLOW: The flow definition. [FlowDefinition](x-source-tag://FlowDefinition)
@available(iOS 13.0, *)
public struct FlowKitSwiftUIView<FLOW: FlowDefinition>: UIViewControllerRepresentable {
    private let viewModel: FlowKitSwiftUIViewModel<FLOW>
    private let navigation: UINavigationController

    ///
    /// Main FlowKitSwiftUIView constructor
    /// - Parameters:
    ///   - viewModel: ViewModel to start the flow
    ///   - navigation: Navigation controller where start the flow
    public init(viewModel: FlowKitSwiftUIViewModel<FLOW>, navigation: UINavigationController = UINavigationController()) {
        self.viewModel = viewModel
        self.navigation = navigation
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        viewModel.start(on: navigation)
        return navigation
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

///
/// FlowKitSwiftUIViewModel struct
/// - Generics
///     - FLOW: The flow definition. [FlowDefinition](x-source-tag://FlowDefinition)
@available(iOS 13.0, *)
public struct FlowKitSwiftUIViewModel<FLOW: FlowDefinition> {
    private let flow: FlowKit<FLOW>
    private let willPerformStep: ((FLOW.STEP) -> Void)?
    private let onErrorHandler: ((FlowKit<FLOW>.FlowError, UINavigationController) -> Void)?
    private let onFinish: (FlowOutput<FLOW.OUTPUT>, UINavigationController) -> Void

    ///
    /// Main FlowKitSwiftUIViewModel constructor
    /// - Parameters:
    ///   - flowData: Data required to build the flow
    ///   - featureStepFactory: Factory for creating your steps
    ///   - willPerformStep: Closure executed when a new step is going to be performed
    ///   - onErrorHandler: Closure executed when flow or step throw an error
    ///   - onFinish: Closure executed when the flow is finished
    public init<T: StepFactory>(
        flowData: FlowData<FLOW.STEP>,
        featureStepFactory: T,
        willPerformStep: ((FLOW.STEP) -> Void)? = nil,
        onErrorHandler: ((FlowKit<FLOW>.FlowError, UINavigationController) -> Void)? = nil,
        onFinish: @escaping (FlowOutput<FLOW.OUTPUT>, UINavigationController) -> Void
    ) where T.OUTPUT == FLOW.OUTPUT, T.STEP == FLOW.STEP {
        self.flow = FlowKit<FLOW>.init(flowData: flowData, featureStepFactory: featureStepFactory)
        self.willPerformStep = willPerformStep
        self.onErrorHandler = onErrorHandler
        self.onFinish = onFinish
    }

    func start(on navigation: UINavigationController) {
        flow.start(
            on: navigation,
            willPerformStep: willPerformStep,
            onErrorHandler: onErrorHandler,
            onFinish: { output in
                self.onFinish(output, navigation)
            }
        )
    }
}

@available(iOS 13.0, *)
extension View {
    public func push(on navigation: UINavigationController, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: self)
        navigation.pushViewController(hostingController, animated: animated)
    }

    public func present(on navigation: UINavigationController, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: self)
        navigation.present(hostingController, animated: animated)
    }
}

