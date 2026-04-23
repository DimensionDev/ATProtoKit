//
//  AppBskyUnspeccedGetPostThreadOtherV2.swift
//  ATProtoKit
//
//  Created by ChuanqingYang on 4/2/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {
    public struct GetPostThreadOtherV2Output: Sendable, Codable {

        public let thread: [ThreadValueDefinition]
    }
}
