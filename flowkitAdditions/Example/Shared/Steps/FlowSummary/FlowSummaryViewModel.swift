//
//  Created by Guillem on 23/7/22.
//

import Foundation

struct FlowSummaryViewModel {

    var title: String {
        "Flow \(flowId) output summary"
    }

    var answers: [String] {
        content.map {
            $0.key + ": " + String(describing: $0.value)
        }
    }

    var primaryButton: ButtonViewModel {
        ButtonViewModel(title: "Submit", action: completion)
    }

    private let content: [String: Any]
    private let flowId: String
    private let completion: () -> Void

    init(
        content: [String: Any],
        flowId: String,
        completion: @escaping () -> Void
    ) {
        self.content = content
        self.flowId = flowId
        self.completion = completion
    }
}
