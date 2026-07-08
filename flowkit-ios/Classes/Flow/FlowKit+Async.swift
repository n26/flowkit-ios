//
//  FlowKit+Async.swift
//  FlowKit
//
//  Additive async/await entry point for starting a flow.
//
//  Design: wraps the existing completion-based `start(on:willPerformStep:onErrorHandler:onFinish:)`
//  in a checked continuation. The completion API remains canonical; this adapter
//  changes no engine behaviour. Errors surfaced through `onErrorHandler` are
//  rethrown, and a normal finish resumes with the flow output — the existing
//  engine guarantees exactly one of the two terminals fires, which maps cleanly
//  onto a single continuation resume.
//
//  Gated to iOS 13 (Swift Concurrency runtime floor) to preserve the package's
//  iOS 12 deployment target for the existing completion API.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public extension FlowKit {
    /// Starts the flow and asynchronously returns its output.
    ///
    /// Async counterpart of ``start(on:willPerformStep:onErrorHandler:onFinish:)``.
    /// Overload resolution disambiguates from the completion-based `start` by the
    /// absence of the required `onFinish` parameter and the `async throws` effect.
    ///
    /// - Parameters:
    ///   - navigation: Navigation controller where the flow is started.
    ///   - willPerformStep: Called when a new step is about to be performed.
    /// - Returns: The flow output produced when the flow finishes.
    /// - Throws: ``FlowKit/FlowError`` if the flow or a step fails.
    @MainActor
    func start(
        on navigation: UINavigationController,
        willPerformStep: ((FLOW.STEP) -> Void)? = nil
    ) async throws -> FlowOutput<FLOW.OUTPUT> {
        try await withCheckedThrowingContinuation { continuation in
            start(
                on: navigation,
                willPerformStep: willPerformStep,
                onErrorHandler: { error, _ in
                    continuation.resume(throwing: error)
                },
                onFinish: { output in
                    continuation.resume(returning: output)
                }
            )
        }
    }
}
