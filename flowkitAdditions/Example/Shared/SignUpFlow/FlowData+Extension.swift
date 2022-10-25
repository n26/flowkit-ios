//
//  Created by Guillem on 30/9/22.
//

import FlowKit

extension FlowData {
    public static var signUpFlowData: FlowData<Step> {
        try! LocalFlowLoader.loadFlow(flowName: "signUpFlowResponse")
    }
}
