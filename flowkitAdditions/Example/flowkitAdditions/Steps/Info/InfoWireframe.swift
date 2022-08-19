//
//  Created by Guillem on 22/7/22.
//

import Foundation
import UIKit
import SwiftUI

final class InfoWireframe {
    static func push(
        on navigation: UINavigationController,
        content: InfoContent,
        completion: @escaping () -> Void
    ) {
        let viewModel = InfoViewModel(content: content, completion: completion)
        let view = InfoView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: view)

        navigation.pushViewController(hostingController, animated: true)
    }
}
