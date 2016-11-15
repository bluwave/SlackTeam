//
//  Profile.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/15/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import Foundation
import Mapper

struct ProfileKeyPaths {
    static let email = "profile.email"
    static let username = "name"
    static let firstName = "profile.first_name"
    static let lastName = "profile.last_name"
    static let realName = "profile.real_name"
    static let title = "profile.title"
    static let imageUrl24 = "profile.image_24"
    static let imageUrl48 = "profile.image_48"
    static let imageUrl72 = "profile.image_72"
    static let imageUrl192 = "profile.image_192"
    static let color = "color"
}

struct Profile: Mappable {
    var email = ""
    var firstName = ""
    var lastName = ""
    var realName = ""
    var title = ""
    var username = ""
    var color = ""
    var imageUrl192 = ""
    var imageUrl72 = ""
    var imageUrl48 = ""
    var imageUrl24 = ""
    
    init() {}
    
    init(map: Mapper) throws {
        email = map.optionalFrom(ProfileKeyPaths.email) ?? ""
        firstName = map.optionalFrom(ProfileKeyPaths.firstName) ?? ""
        lastName = map.optionalFrom(ProfileKeyPaths.lastName) ?? ""
        realName = map.optionalFrom(ProfileKeyPaths.realName) ?? ""
        title = map.optionalFrom(ProfileKeyPaths.title) ?? ""
        username = map.optionalFrom(ProfileKeyPaths.username) ?? ""
        color = map.optionalFrom(ProfileKeyPaths.color) ?? ""
        imageUrl192 = map.optionalFrom(ProfileKeyPaths.imageUrl192) ?? ""
        imageUrl72 = map.optionalFrom(ProfileKeyPaths.imageUrl72) ?? ""
        imageUrl48 = map.optionalFrom(ProfileKeyPaths.imageUrl48) ?? ""
        imageUrl24 = map.optionalFrom(ProfileKeyPaths.imageUrl24) ?? ""
    }
}

struct ProfileResponse: Mappable {
    var profiles: [Profile] = []
    
    init() {}
    
    init(map: Mapper) throws {
        profiles = map.optionalFrom("members") ?? []
    }
}
