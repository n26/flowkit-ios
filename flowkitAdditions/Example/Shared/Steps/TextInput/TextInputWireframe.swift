//
//  Created by Guillem on 22/7/22.
//

import Foundation
import UIKit

final class TextInputWireframe {
    static func push(
        on navigation: UINavigationController,
        content: TextInputContent,
        completion: @escaping (String?) -> Void
    ) {
        let viewModel = TextInputViewModel(content: content, completion: completion)
        TextInputView(viewModel: viewModel).push(on: navigation)
    }
}
