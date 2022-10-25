//
//  Created by Guillem on 22/7/22.
//

import Foundation
import SwiftUI

final class FlowListWireframe {
    static func createRootView() -> some View {
        let viewModel = FlowListViewModel()
        return FlowListView(viewModel: viewModel)
    }
}
