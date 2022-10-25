//
//  Created by Guillem on 22/7/22.
//

import Foundation
import FlowKit

final class LocalFlowLoader {
    private static var bundle: Bundle {
        let codeBundle = Bundle(for: LocalFlowLoader.self)
        guard let subBundleUrl = codeBundle.url(forResource: "SharedResources",
                                                withExtension: "bundle"),
            let resourceBundle = Bundle(url: subBundleUrl) else {
                fatalError("misconfigured bundle")
        }
        return resourceBundle
    }

    enum FileLoaderError: Error {
        case fileNotFound
        case wrongFilePathURL
        case invalidFlowData
    }

    static func loadFlow(flowName: String) throws -> FlowData<Step> {
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
