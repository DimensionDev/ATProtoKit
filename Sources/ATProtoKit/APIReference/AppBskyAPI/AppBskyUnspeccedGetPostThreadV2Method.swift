//
//  AppBskyUnspeccedGetPostThreadV2Method.swift
//  ATProtoKit
//
//  Created by ChuanqingYang on 4/1/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    public func getGetPostThreadV2(
        postURI anchor: String,
        branchingFactor: Int? = 1,
        below: Int? = 10,
        sort: String? = "top"
    ) async throws -> AppBskyLexicon.Unspecced.GetPostThreadV2Output {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getPostThreadV2") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()
        
        queryItems.append(("anchor", anchor))

        if let branchingFactor {
            queryItems.append(("branchingFactor", "\(branchingFactor)"))
        }
        
        if let below {
            queryItems.append(("below", "\(below)"))
        }
        
        if let sort {
            queryItems.append(("sort", sort))
        }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetPostThreadV2Output.self
            )

            return response
        } catch {
            throw error
        }
    }
}
