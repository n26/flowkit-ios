//
//  Created by Guillem on 22/7/22.
//

import FlowKit
import Shared

final class FlowListViewModel: ObservableObject {
    @Published var selectedFlow: FlowListViewModel.Flow?

    struct Flow: Identifiable {
        enum FlowType {
            case signUp
        }

        let id: String
        let title: String
        let type: FlowType
    }

    var title: String {
        "FlowKit Demo"
    }

    var flows: [Flow] {
        [
            Flow(id: "1", title: "🔐 Sign up flow", type: .signUp)
            // TODO: Add more example flows
        ]
    }

    func openFlow(_ flow: Flow) {
        selectedFlow = flow
    }
    
    var signUpFlowViewModel: FlowKitSwiftUIViewModel<SignUpFlowDefinition> {
        return FlowKitSwiftUIViewModel<SignUpFlowDefinition>(
            flowData: FlowData<Step>.signUpFlowData,
            featureStepFactory: SignUpStepFactory()
        ) { step in
            print("Will present step \(step.id)")
        } onErrorHandler: { error, navigation in
            FlowErrorWireframe.push(on: navigation, error: error) { }
        } onFinish: { [weak self] output, _ in
            print("Flow output: \(output.rawData.description)")
            self?.selectedFlow = nil
        }
    }
}
