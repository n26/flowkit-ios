//
//  Created by Guillem on 22/7/22.
//

import Foundation
import SwiftUI

final class TextInputViewModel: ObservableObject {
    var title: String {
        content.title
    }

    var subtitle: String? {
        content.subtitle
    }

    var placeholder: String {
        content.placeholder
    }

    var skipButton: ButtonViewModel? {
        guard let skipButtonText = content.skipButtonText else { return nil }
        return ButtonViewModel(title: skipButtonText, action: tapSkipButton)
    }

    var primaryButton: ButtonViewModel {
        ButtonViewModel(
            title: content.primaryButtonText,
            isEnabled: !text.isEmpty,
            action: tapPrimaryButton
        )
    }

    @Published var text: String = ""

    private let content: TextInputContent
    private let completion: (String?) -> Void

    init(content: TextInputContent, completion: @escaping (String?) -> Void) {
        self.content = content
        self.completion = completion
    }

    private func tapPrimaryButton() {
        completion(text)
    }

    private func tapSkipButton() {
        completion(nil)
    }
}
