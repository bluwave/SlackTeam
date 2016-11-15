//
//  SlackClient.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/14/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import Foundation
import Alamofire
import Mapper

typealias SlackClientHandler = ([Profile]?, Error?) -> Void

struct SlackConstants {
    struct Server {
        static let baseUrl = "https://slack.com"
        static let userListPath = "/api/users.list"
        static let urlParamToken = "token"
        static let serverToken = "<SLACK API TOKEN HERE>"
    }
}

class SlackClient {
    
    var sessionManager: SessionManager = SessionManager.default
    
    func fetchProfiles(handler: @escaping SlackClientHandler) {
        let url = "\(SlackConstants.Server.baseUrl)\(SlackConstants.Server.userListPath)?\(SlackConstants.Server.urlParamToken)=\(SlackConstants.Server.serverToken)"
        sessionManager.request(url).responseJSON{ (response) in
            switch response.result {
            case .success:
                if let serverError = self.parseError(response.result.value) {
                    handler(nil, serverError)
                }
                else if let data = response.result.value as? NSDictionary, let profileResponse = ProfileResponse.from(data) {
                    handler(profileResponse.profiles, nil)
                }
                else {
                    let error = NSError.internalError(message: "Invalid Response")
                    handler(nil, error)
                }
            case .failure(let error):
                print("\(#function) error: \(error)")
                handler(nil, error)
            }
        }
    }
    
    func parseError(_ json: Any?) -> NSError? {
        if let dictionary = json as? [String: Any], let errorString = dictionary["error"] as? String {
            return NSError.internalError(message: errorString)
        }
        return nil
    }
}
