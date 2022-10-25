//
//  Created by Guillem on 22/7/22.
//

import Foundation
import FlowKit
import Shared

final class SignUpFlow {
    static func present(in navigation: UINavigationController) {
        let flowNavigation = UINavigationController()

        startFlow(in: flowNavigation)

        navigation.present(flowNavigation, animated: true)
    }

    static func startFlow(in navigation: UINavigationController) {
        let flow = FlowKit<SignUpFlowDefinition>(flowData: FlowData<Step>.signUpFlowData, featureStepFactory: SignUpStepFactory())

        flow.start(on: navigation) { step in
            print("Will present step \(step.id)")
        } onErrorHandler: { error, navigation in
            FlowErrorWireframe.push(on: navigation, error: error) { }
        } onFinish: { output in
            print("Flow output: \(output.rawData.description)")
            navigation.dismiss(animated: true)
        }
    }
}
