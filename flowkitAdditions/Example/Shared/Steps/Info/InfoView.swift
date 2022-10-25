//
//  Created by Guillem on 22/7/22.
//

import SwiftUI

struct InfoView: View {
    let viewModel: InfoViewModel

    var body: some View {
        VStack {
            TitleText(viewModel.title)
            BodyText(viewModel.description)
            PrimaryButton(viewModel: viewModel.primaryButton)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}
