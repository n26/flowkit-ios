//
//  Created by Guillem on 22/7/22.
//

import Foundation

struct InfoViewModel {
    var title: String {
        content.title
    }

    var description: String {
        content.description
    }

    var primaryButton: ButtonViewModel {
        ButtonViewModel(title: content.primaryButtonText, action: completion)
    }

    private let content: InfoContent
    private let completion: () -> Void

    init(content: InfoContent, completion: @escaping () -> Void) {
        self.content = content
        self.completion = completion
    }
}
