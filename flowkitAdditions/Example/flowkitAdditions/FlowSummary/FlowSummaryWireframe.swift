//
//  Created by Guillem on 23/7/22.
//

import Foundation
import UIKit
import SwiftUI

final class FlowSummaryWireframe {
    static func push(
        on navigation: UINavigationController,
        flowId: String,
        currentOutput: [String: Any],
        completion: @escaping () -> Void
    ) {
        let viewModel = FlowSummaryViewModel(content: currentOutput, flowId: flowId, completion: completion)

        let view = FlowSummaryView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: view)

        navigation.pushViewController(hostingController, animated: true)
    }
}
