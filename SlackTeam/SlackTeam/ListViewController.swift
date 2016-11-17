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
    var pushAnimator: CircularTransitionAnimator?
    var selectedCellIndexPath: IndexPath?
    
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
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < profiles.count {
            navigationController?.delegate = self
            selectedCellIndexPath = indexPath
            configurePushAnimator(forRowAt: indexPath)
            let profileDetailsViewController = DetailViewController(nibName: String(describing: DetailViewController.self), bundle: nil)
            profileDetailsViewController.profile = profiles[indexPath.row]
            navigationController?.pushViewController(profileDetailsViewController, animated: true)
        }
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

extension ListViewController: UINavigationControllerDelegate {
    
    func configurePushAnimator(forRowAt indexPath: IndexPath) {
        pushAnimator = CircularTransitionAnimator()
        pushAnimator?.blurImage = blurredImageOfView()
        
        if let cell = tableView.cellForRow(at: indexPath) as? ListViewControllerTableViewCell {
            pushAnimator?.profileImage = cell.profileImageView.image
        }
        pushAnimator?.profileColor = UIColor.hx_color(withHexRGBAString: profiles[indexPath.row].color)
    }
    
    func blurredImageOfView() -> UIImage? {
        let image = view.snapshotWithScale(scale: 1.0)
        return image?.gr_blurredImage(withRadius: 12, iterations: 3, tintColor: nil)
    }
    
    func selectedRectForPushAnimation() -> CGRect {
        if let selectedCellIndexPath = selectedCellIndexPath {
            var cellRectInView = tableView.rectForRow(at: selectedCellIndexPath)
            let yOffset = tableView.contentOffset
            cellRectInView = cellRectInView.offsetBy(dx: -yOffset.x, dy: -yOffset.y - self.tableView.contentInset.top)
            
            if let cell = tableView.cellForRow(at: selectedCellIndexPath) as? ListViewControllerTableViewCell {
                let cellImageViewRect = tableView.convert(cell.profileImageView.frame, from: tableView)
                cellRectInView.origin.x += cellImageViewRect.origin.x
                cellRectInView.origin.y += cellImageViewRect.origin.y + self.topLayoutGuide.length
                cellRectInView.size = cell.profileImageView.frame.size
                cellRectInView = view.convert(cellRectInView, from: view)
                return cellRectInView
            }
        }
        
        return CGRect.zero
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .push) {
            pushAnimator?.selectedProfileRect = selectedRectForPushAnimation()
            return self.pushAnimator;
        }
        return nil;
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

class CircularTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    weak var transitionContext: UIViewControllerContextTransitioning?
    var selectedProfileRect = CGRect.zero
    var blurImage: UIImage?
    var profileImage: UIImage?
    var profileColor: UIColor? = UIColor.clear
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.black
        
        if let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? DetailViewController,
            let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        {
            to.view.frame = from.view.frame
            
            //  setup blurred bg image
            configureBlurredImageBackground(destinationView: to.view)
            
            //  setup profile image to animate to next viewController positions
            let profileImageView = configureProfileImageView(destinationView: to.view)
            
            //  add views to containerView
            containerView.addSubview(from.view)
            containerView.addSubview(to.view)
            
            //  animation for the circlular mask from previous viewController profile image
            animateGrowingCircle(containerView: containerView, to: to.view)
            
            //  Animate profile image to correct position
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                profileImageView.center = to.view.center
            })
        }
    }
    
    func configureProfileImageView(destinationView: UIView) -> UIImageView {
        let profileImageView = UIImageView(image: profileImage)
        profileImageView.frame = selectedProfileRect
        profileImageView.makeCircular()
        profileImageView.layer.borderColor = profileColor?.cgColor
        profileImageView.layer.borderWidth = 4.0
        destinationView.addSubview(profileImageView)
        return profileImageView
    }
    
    func configureBlurredImageBackground(destinationView: UIView) {
        let blurredBgImageView = UIImageView(image: blurImage)
        blurredBgImageView.contentMode = .scaleAspectFill
        blurredBgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destinationView.insertSubview(blurredBgImageView, at: 0)
    }
    
    func animateGrowingCircle(containerView: UIView, to maskedView: UIView) {
        let startRect = selectedProfileRect
        let circleMaskPathInitial: UIBezierPath = UIBezierPath(ovalIn: startRect)
        
        let padding: CGFloat = 200   // useful for ipad landscape
        let extremePoint = CGPoint(x: containerView.center.x, y: maskedView.bounds.height + padding)
        let radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y))
        let circleMaskFinal = UIBezierPath(ovalIn: startRect.insetBy(dx: -radius, dy: -radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskFinal.cgPath
        maskedView.layer.mask = maskLayer
        
        let keyPath = "path"
        let maskLayerAnimation = CABasicAnimation(keyPath: keyPath)
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskFinal.cgPath
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: keyPath)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(!(self.transitionContext?.transitionWasCancelled ?? true))
        transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
    }
}
