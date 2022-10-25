//
//  Created by Guillem on 23/7/22.
//

import SwiftUI

struct TitleText: View {
    private let text: String
    private let alignment: Alignment

    init(_ text: String, alignment: Alignment = .leading) {
        self.text = text
        self.alignment = alignment
    }

    var body: some View {
        Text(text)
            .font(Font.title)
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(.horizontal)
            .padding(.bottom)
    }
}
