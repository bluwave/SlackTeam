//
//  SlackClient.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/14/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import Foundation
import Alamofire

typealias GenericDictionary = [String: Any]
typealias SlackClientHandler = ([GenericDictionary]?, Error?) -> Void

struct SlackConstants {
    struct Server {
        static var baseUrl = "https://slack.com"
        static var userListPath = "/api/users.list"
        static var urlParamToken = "token"
        static var serverToken = ""
    }
    struct ResponseKeyPaths {
        static var profileEmail = "profile.email"
        static var serverID = "id"
        static var profileUsername = "name"
        static var profileFirstName = "profile.first_name"
        static var profileLastName = "profile.last_name"
        static var profileRealName = "profile.real_name"
        static var profileTitle = "profile.title"
        static var profileImageURL24 = "profile.image_24"
        static var profileImageURL48 = "profile.image_48"
        static var profileImageURL72 = "profile.image_72"
        static var profileImageURL192 = "profile.image_192"
        static var profileColor = "color"
    }
}

class SlackClient {
    
    var sessionManager: SessionManager?
    
    func fetchProfiles(handler: SlackClientHandler) {
        let url = "\(SlackConstants.Server.baseUrl)\(SlackConstants.Server.userListPath)?\(SlackConstants.Server.urlParamToken)=\(SlackConstants.Server.serverToken)"
        self.sessionManager?.request(url).responseJSON{ (response) in
            switch response.result {
            case .success:
                print("result: \(response.result.value)")
            case .failure(let error):
                print("\(#function) error: \(error)")
            }
        }
    }
}
