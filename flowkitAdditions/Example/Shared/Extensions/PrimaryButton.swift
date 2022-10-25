//
//  Created by Guillem on 23/7/22.
//

import SwiftUI

struct PrimaryButton: View {
    let viewModel: ButtonViewModel

    var body: some View {
        Button(action: viewModel.action) {
            Text(viewModel.title)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(!viewModel.isEnabled)
    }
}

fileprivate struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.button)
            .padding(16)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(isEnabled ? Color.teal : Color.teal.disabled)
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}
