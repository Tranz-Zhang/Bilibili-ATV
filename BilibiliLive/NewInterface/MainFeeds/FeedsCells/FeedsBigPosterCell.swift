//
//  FeedsBigPosterCell.swift
//  StudyAppleTVUI
//
//  Created by ByteDance on 2024/2/7.
//

import Kingfisher
import UIKit

class FeedsBigPosterCell: FeedsBaseCell, FeedsCellDataUpdateProtocol {
    static let reuseIdentifier = "FeedsBigPosterCell.reuseIdentifier"
    static let nibName = "FeedsBigPosterCell"

    @IBOutlet var coverView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var creatorNameLabel: UILabel!
    @IBOutlet var creatorAvatarView: UIImageView!
    @IBOutlet var tagsView: UIButton!
    @IBOutlet var infoPanelView: UIView!

    static func sectionLayout() -> NSCollectionLayoutSection {
        /// create item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        /// create group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(960),
                                               heightDimension: .absolute(600))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    func updateData(_ item: FeedsItem) {
        coverView.kf.setImage(with: item.coverURL)
        titleLabel.text = item.title
        durationLabel.text = String.durationString(item.videoDuration)
        creatorAvatarView.kf.setImage(with: item.creatorAvatarURL)
        creatorNameLabel.text = item.creatorName
        FeedsBaseCell.setupTags(item.tags, toView: tagsView)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius = 20
        coverView.layer.cornerCurve = .continuous
        coverView.layer.cornerRadius = 20
        creatorAvatarView.layer.cornerCurve = .circular
        creatorAvatarView.layer.cornerRadius = creatorAvatarView.frame.size.height / 2
    }

    // MARK: parallax setup

    override func setupParallax() {
        // Here you can configure custom properties for parallax effect
        parallaxEffectOptions.glowAlpha = 0.4
        parallaxEffectOptions.shadowPanDeviation = 10
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleX = CGFloat(Double.pi / 4 / 30)
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleY = CGFloat(Double.pi / 4 / 30)
        parallaxEffectOptions.parallaxMotionEffect.panValue = CGFloat(10)
        parallaxEffectOptions.glowPosition = .center

        // You can customise parallax view standard behaviours using parallaxViewActions property.
        // Do not forget to use weak self if needed to void retain cycle
        parallaxViewActions.setupUnfocusedState = { view in
            view.transform = CGAffineTransform.identity

            view.layer.shadowOffset = CGSize(width: 0, height: 3)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 5

            self.infoPanelView.alpha = 0
        }

        parallaxViewActions.setupFocusedState = { view in
            view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

            view.layer.shadowOffset = CGSize(width: 0, height: 20)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 20

            self.infoPanelView.alpha = 1
        }
    }
}
