//
//  AppBskyUnspeccedGetPostThreadV2.swift
//  ATProtoKit
//
//  Created by ChuanqingYang on 4/2/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {
    public struct GetPostThreadV2Output: Sendable, Codable {

        /// An array of feeds.
        public let hasOtherReplies: Bool
        public let thread: [ThreadValueDefinition]
    }
    
    public struct ThreadValueDefinition: Codable, Sendable {
        public let depth: Int
        public let uri: String
        public let value: ValueUnion?
        
        public indirect enum ValueUnion: ATUnionProtocol, Equatable, Hashable {

            /// The view of a post.
            case threadItemPost(AppBskyLexicon.Unspecced.ThreadItemPostDefinition)

            /// The view of a post that may not have been found.
            case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

            /// The view of a post that's been blocked by the post author.
            case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.unspecced.defs#threadItemPost":
                        self = .threadItemPost(try AppBskyLexicon.Unspecced.ThreadItemPostDefinition(from: decoder))
//                    case "app.bsky.unspecced.defs#notFoundPost":
//                        self = .notFoundPost(try AppBskyLexicon.Feed.NotFoundPostDefinition(from: decoder))
//                    case "app.bsky.unspecced.defs#blockedPost":
//                        self = .blockedPost(try AppBskyLexicon.Feed.BlockedPostDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .threadItemPost(let value):
                        try container.encode(value)
                    case .notFoundPost(let value):
                        try container.encode(value)
                    case .blockedPost(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
    
    public struct ThreadItemPostDefinition: Sendable, Codable, Equatable, Hashable {
        
        public let hiddenByThreadgate: Bool
        public let moreParents: Bool
        public let moreReplies: Bool
        public let mutedByViewer: Bool
        public let opThread: Bool
        public let post: AppBskyLexicon.Feed.PostViewDefinition
    }
}
