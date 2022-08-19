//
//  Created by Guillem on 24/7/22.
//

import SwiftUI

struct TextInput: View {
    private let placeholder: String
    private let text: Binding<String>

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self.text = text
    }

    var body: some View {
        TextField(placeholder, text: text)
            .font(Font.smallBody)
            .accentColor(Color.teal)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            .padding()
    }
}
