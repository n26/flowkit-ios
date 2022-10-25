//
//  Created by Guillem on 22/7/22.
//

import Foundation
import UIKit
import FlowKit

public final class FlowErrorWireframe {
    public static func push<T: FlowDefinition>(
        on navigation: UINavigationController,
        error: FlowKit<T>.FlowError,
        retry: @escaping () -> Void
    ) {
        let viewModel = FlowErrorViewModel(error: error, retryCallback: retry)
        FlowErrorView(viewModel: viewModel).push(on: navigation)
    }
}
