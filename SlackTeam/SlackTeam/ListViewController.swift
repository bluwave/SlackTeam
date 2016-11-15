//
//  ListViewController.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/14/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import UIKit
import HexColors
import SDWebImage

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "cell"
    let apiClient = SlackClient()
    var profiles = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOLLYWOOD's HOTTEST STARS USING SLACK"
        configureTableView()
        fetchProfiles()
    }

    func configureTableView() {
        let nib = UINib(nibName: String(describing: ListViewControllerTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func fetchProfiles() {
        apiClient.fetchProfiles { [weak self] (profiles, error) in
            if let error = error {
                //  FIXME: - surface errors
                print(error)
            }
            else if let profiles = profiles {
                self?.profiles = profiles
                self?.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListViewControllerTableViewCell
        if indexPath.row < profiles.count {
            cell.configureWithProfile(profile: profiles[indexPath.row])
        }
        return cell
    }
}

class ListViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSelectionBackgroundColor()
        configureProfileImage()
    }
    
    func configureProfileImage() {
        profileImageView.makeCircular()
        profileImageView.layer.borderWidth = 4.0
    }
    
    func configureSelectionBackgroundColor() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
        self.selectedBackgroundView = bgColorView
    }
    
    func configureWithProfile(profile: Profile) {
        let profileColor = UIColor.hx_color(withHexRGBAString: profile.color)
        nameLabel.text = profile.realName
        titleLabel.text = profile.title
        titleLabel.textColor = profileColor
        usernameLabel.text = profile.username
        profileImageView.layer.borderColor = profileColor?.cgColor
        if let imageUrl = URL(string: profile.imageUrl72) {
            profileImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "profilePlaceholder"))
        }
    }
}
