//
//  Created by Guillem on 22/7/22.
//

import FlowKit

struct FlowErrorViewModel<T: FlowDefinition> {
    var errorImage: String {
        "exclamationmark.icloud.fill"
    }

    var title: String {
        "Error"
    }

    var description: String {
        switch error {
        case .stepContentNotDecodable(let stepInfo):
            return "Step content not decodable. Review step id: \(stepInfo.id), step type: \(stepInfo.type)"
        case .multipleMatchingConditions(let stepInfo):
            return "Multiple steps conditions match. Review step id: \(stepInfo.id), step type: \(stepInfo.type)"
        case .cannotCreateStepHandler(let stepInfo):
            return "Can't create stepHandler. Review step id: \(stepInfo.id), step type: \(stepInfo.type)"
        case .cannotCreateFlow(let stepError):
            switch stepError {
            case .initialStepNotFound(let stepId):
                return "Initial step not found. Review step id: \(stepId)"
            case .stepNotFound(let stepId):
                return "Next steps not found. Review step id: \(stepId)"
            case .flowMalformed(let stepId):
                return "Loop detected. Review step id: \(stepId)"
            }
        case .unknownError:
            return "Unknown error"
        }
    }

    var retryButton: ButtonViewModel {
        ButtonViewModel(title: "Retry", action: retryCallback)
    }

    
    private let error: FlowKit<T>.FlowError
    private let retryCallback: () -> Void

    init(error: FlowKit<T>.FlowError, retryCallback: @escaping () -> Void) {
        self.error = error
        self.retryCallback = retryCallback
    }
}
