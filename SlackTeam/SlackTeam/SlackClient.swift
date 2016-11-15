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
        static var baseUrl = "https://slack.com"
        static var userListPath = "/api/users.list"
        static var urlParamToken = "token"
        static var serverToken = ""
    }
}

class SlackClient {
    
    var sessionManager: SessionManager = SessionManager.default
    
    func fetchProfiles(handler: @escaping SlackClientHandler) {
        let url = "\(SlackConstants.Server.baseUrl)\(SlackConstants.Server.userListPath)?\(SlackConstants.Server.urlParamToken)=\(SlackConstants.Server.serverToken)"
        sessionManager.request(url).responseJSON{ (response) in
            switch response.result {
            case .success:
                if let data = response.result.value as? NSDictionary, let profileResponse = ProfileResponse.from(data) {
                    handler(profileResponse.profiles, nil)
                }
                else {
                    let error = NSError(domain: "com.acme.slackClient", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    handler(nil, error)
                }
            case .failure(let error):
                print("\(#function) error: \(error)")
                handler(nil, error)
            }
        }
    }
}
