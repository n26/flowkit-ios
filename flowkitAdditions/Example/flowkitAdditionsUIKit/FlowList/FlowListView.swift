//
//  Created by Guillem on 22/7/22.
//

import Foundation
import SwiftUI

struct FlowListView: View {
    let viewModel: FlowListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.flows) { flow in
                Button(action: flow.openFlow) {
                    Text(flow.title)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.vertical)
                }
            }
            .navigationTitle(viewModel.title)
        }
    }
}
