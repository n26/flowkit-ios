//
//  Created by Guillem on 23/7/22.
//

import SwiftUI

extension Color {
    static let teal = Color("tealColor")

    var disabled: Color {
        self.opacity(0.7)
    }
}
