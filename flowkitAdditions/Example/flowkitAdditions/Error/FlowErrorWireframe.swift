//
//  Created by Guillem on 22/7/22.
//

import Foundation
import UIKit
import SwiftUI
import FlowKit

final class FlowErrorWireframe {
    static func push<T: FlowDefinition>(
        on navigation: UINavigationController,
        error: FlowKit<T>.FlowError,
        retry: @escaping () -> Void
    ) {
        let viewModel = FlowErrorViewModel(error: error, retryCallback: retry)
        let view = FlowErrorView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: view)

        navigation.pushViewController(hostingController, animated: true)
    }
}
