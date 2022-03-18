//
// Created by Alex Martinez on 23/2/22.
//

import Foundation

public protocol StepOutput { }

public struct StepOutputEmpty: StepOutput { }

extension String: StepOutput { }

extension Date: StepOutput { }

extension Array: StepOutput { }

extension Bool: StepOutput { }
