//
// Created by Alex Martinez on 23/2/22.
//

import Foundation

/// Interface that a step output has to implement
public protocol StepOutput { }

/// - Tag: StepOutputEmpty
public struct StepOutputEmpty: StepOutput { }

extension String: StepOutput { }

extension Date: StepOutput { }

extension Array: StepOutput { }

extension Bool: StepOutput { }
