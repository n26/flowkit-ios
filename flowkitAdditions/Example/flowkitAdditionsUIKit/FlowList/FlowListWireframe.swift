//
//  Created by Guillem on 22/7/22.
//

import Foundation
import UIKit
import SwiftUI

protocol FlowListWireframeType {
    func openSignUpFlow()
}

final class FlowListWireframe: FlowListWireframeType {
    private unowned let navigation: UINavigationController

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    static func createRootView() -> UINavigationController {
        let navigation = UINavigationController()

        let wireframe = FlowListWireframe(navigation: navigation)

        let viewController = wireframe.createViewController()

        navigation.setViewControllers([viewController], animated: true)

        return navigation
    }

    func createViewController() -> UIViewController {
        let viewModel = FlowListViewModel(navigation: self)
        let view = FlowListView(viewModel: viewModel)

        return UIHostingController(rootView: view)
    }

    func openSignUpFlow() {
        SignUpFlow.present(in: navigation)
    }
}
