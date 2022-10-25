//
//  Created by Guillem on 22/7/22.
//

import Foundation
import UIKit

final class InfoWireframe {
    static func push(
        on navigation: UINavigationController,
        content: InfoContent,
        completion: @escaping () -> Void
    ) {
        let viewModel = InfoViewModel(content: content, completion: completion)
        InfoView(viewModel: viewModel).push(on: navigation)
    }
}
