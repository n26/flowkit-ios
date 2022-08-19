//
//  Created by Guillem on 22/7/22.
//

import Foundation
import UIKit
import SwiftUI

final class TextInputWireframe {
    static func push(
        on navigation: UINavigationController,
        content: TextInputContent,
        completion: @escaping (String?) -> Void
    ) {
        let viewModel = TextInputViewModel(content: content, completion: completion)
        let view = TextInputView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: view)

        navigation.pushViewController(hostingController, animated: true)
    }
}
