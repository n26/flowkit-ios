//
//  Created by Guillem on 23/7/22.
//

import Foundation
import SwiftUI

struct FlowSummaryView: View {
    let viewModel: FlowSummaryViewModel

    var body: some View {
        VStack {
            TitleText(viewModel.title)
            ForEach(viewModel.answers, id: \.self) {
                BodyText($0)
            }
            PrimaryButton(viewModel: viewModel.primaryButton)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}
