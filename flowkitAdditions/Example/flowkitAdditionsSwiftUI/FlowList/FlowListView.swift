//
//  Created by Guillem on 22/7/22.
//

import SwiftUI
import FlowKit
import Shared

struct FlowListView: View {
    @ObservedObject var viewModel: FlowListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.flows) { flow in
                Button {
                    viewModel.openFlow(flow)
                } label: {
                    Text(flow.title)
                        .font(.body)
                        .padding(.vertical)
                }
            }
            .navigationTitle(viewModel.title)
            .sheet(item: $viewModel.selectedFlow) { flow in
                switch flow.type {
                case .signUp:
                    FlowKitSwiftUIView<SignUpFlowDefinition>(viewModel: viewModel.signUpFlowViewModel)
                }
            }
        }
    }
}
