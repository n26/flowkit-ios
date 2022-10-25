//
//  Created by Guillem on 22/7/22.
//

import Foundation

struct TextInputContent: Decodable {
    let title: String
    let subtitle: String?
    let placeholder: String
    let primaryButtonText: String
    let skipButtonText: String?
}
