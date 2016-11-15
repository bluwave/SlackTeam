//
//  ListViewController.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/14/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOLLYWOOD's HOTTEST STARS USING SLACK"
        configureTableView()
    }

    func configureTableView() {
        let nib = UINib(nibName: String(describing: ListViewControllerTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "row \(indexPath.row)"
        
        return cell
    }
}

class ListViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func awaeFromNib() {
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
}
