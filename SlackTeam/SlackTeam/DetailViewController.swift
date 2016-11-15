//
//  DetailViewController.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/15/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var largeProfileImageView: UIImageView!
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = profile {
            configureWithProfile(profile: profile)
        }
    }
    
    func configureWithProfile(profile: Profile) {
        usernameLabel.text = profile.username
        nameLabel.text = profile.realName
        titleLabel.text = profile.title
        if let imageUrl = URL(string: profile.imageUrl72) {
            largeProfileImageView.sd_setImage(with: imageUrl, completed: { [weak self] (image, error, cacheType, url) in
                 self?.largeProfileImageView.image = image?.gr_blurredImage(withRadius: 3.0, iterations: 3, tintColor: UIColor.black)
            })
        }
    }
}
