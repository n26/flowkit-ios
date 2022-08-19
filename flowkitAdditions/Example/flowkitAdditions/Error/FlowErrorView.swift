//
//  Created by Guillem on 22/7/22.
//

import Foundation
import SwiftUI
import FlowKit

struct FlowErrorView<T: FlowDefinition>: View {
    let viewModel: FlowErrorViewModel<T>
    
    var body: some View {
        VStack {
            Image(systemName: viewModel.errorImage)
                .foregroundColor(.gray)
                .font(.system(size: 50, weight: .heavy))
                .padding(.bottom)
            TitleText(viewModel.title, alignment: .center)
            BodyText(viewModel.description, alignment: .center)
            SecondaryButton(viewModel: viewModel.retryButton)
        }
    }
}
