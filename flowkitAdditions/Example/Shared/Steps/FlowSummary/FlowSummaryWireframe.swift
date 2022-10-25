//
//  Created by Guillem on 23/7/22.
//

import Foundation
import UIKit

final class FlowSummaryWireframe {
    static func push(
        on navigation: UINavigationController,
        flowId: String,
        currentOutput: [String: Any],
        completion: @escaping () -> Void
    ) {
        let viewModel = FlowSummaryViewModel(content: currentOutput, flowId: flowId, completion: completion)
        FlowSummaryView(viewModel: viewModel).push(on: navigation)
    }
}
