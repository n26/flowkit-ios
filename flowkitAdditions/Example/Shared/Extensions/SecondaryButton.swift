//
//  Created by Guillem on 23/7/22.
//

import SwiftUI

struct SecondaryButton: View {
    let viewModel: ButtonViewModel

    var body: some View {
        Button(action: viewModel.action) {
            Text(viewModel.title)
        }
        .buttonStyle(SecondaryButtonStyle())
        .disabled(!viewModel.isEnabled)
    }
}

fileprivate struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.button)
            .padding(16)
            .foregroundColor(isEnabled ? Color.teal : Color.teal.disabled)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}
