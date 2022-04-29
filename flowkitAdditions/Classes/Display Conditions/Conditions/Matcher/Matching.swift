//
//  Matching.swift
//  flowkit-ios
//
//  Created by Giulio Lombardo  on 28/04/22.
//

protocol Matching {
    func match(stepId: String, input: [String: Any]) -> Bool
}
