//
//  Created by Guillem on 22/7/22.
//

import Foundation
import FlowKit

public protocol LocalFlowLoaderType: AnyObject {
    static func loadFlow(flowName: String, bundle: Bundle) throws -> FlowData<Step>
}

final class LocalFlowLoader: LocalFlowLoaderType {
    enum FileLoaderError: Error {
        case fileNotFound
        case wrongFilePathURL
        case invalidFlowData
    }

    static func loadFlow(flowName: String, bundle: Bundle) throws -> FlowData<Step> {
        guard let fileURL = bundle.url(forResource: flowName, withExtension: ".json") else {
            throw FileLoaderError.fileNotFound
        }

        guard let data = try? Data(contentsOf: fileURL) else {
            throw FileLoaderError.wrongFilePathURL
        }

        guard let flowData = try? JSONDecoder().decode(FlowData<Step>.self, from: data) else {
            throw FileLoaderError.invalidFlowData
        }

        return flowData
    }
}
