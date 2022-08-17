//
//  Created by Guillem on 22/7/22.
//

import SwiftUI

struct TextInputView: View {
    @ObservedObject var viewModel: TextInputViewModel

    var body: some View {
        VStack {
            TitleText(viewModel.title)
            if let subtitle = viewModel.subtitle {
                BodyText(subtitle)
            }
            TextInput(viewModel.placeholder, text: $viewModel.text)
            VStack {
                if let skipButton = viewModel.skipButton {
                    SecondaryButton(viewModel: skipButton)
                }
                PrimaryButton(viewModel: viewModel.primaryButton)
            }.frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}
