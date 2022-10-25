//
//  Created by Guillem on 22/7/22.
//

import Shared

struct FlowListViewModel {
    struct Flow: Identifiable {
        let id: String
        let title: String
        let openFlow: () -> Void
    }

    var title: String {
        "FlowKit Demo"
    }
    var flows: [Flow] {
        [
            Flow(id: "1", title: "🔐 Sign up flow", openFlow: navigation.openSignUpFlow)
            // TODO: Add more example flows
        ]
    }

    private let navigation: FlowListWireframeType

    init(navigation: FlowListWireframeType) {
        self.navigation = navigation
    }
}
