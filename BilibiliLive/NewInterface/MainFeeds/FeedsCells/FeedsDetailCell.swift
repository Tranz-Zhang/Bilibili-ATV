//
//  FeedsDetailCell.swift
//  StudyAppleTVUI
//
//  Created by Chance Zhang on 2024/2/6.
//

import ParallaxView
import UIKit

class FeedsDetailCell: FeedsBaseCell, FeedsCellDataUpdateProtocol {
    static let reuseIdentifier = "FeedsDetailCell.reuseIdentifier"
    static let nibName = "FeedsDetailCell"

    @IBOutlet var coverView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var infoPanelView: UIView!
    @IBOutlet var coverContainerView: UIView!

    @IBOutlet var creatorNameLabel: UILabel!
    @IBOutlet var creatorAvatarView: UIImageView!
    @IBOutlet var tagsView: UIButton!

    static func sectionLayout() -> NSCollectionLayoutSection {
        /// create item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        /// create group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(540),
                                               heightDimension: .absolute(460))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    func updateData(_ item: FeedsItem) {
//        self.coverView.image = ...
        titleLabel.text = item.title
        durationLabel.text = String.durationString(item.videoDuration)
//        self.creatorAvatarView.image = ...
        creatorNameLabel.text = item.creatorName
        FeedsBaseCell.setupTags(item.tags, toView: tagsView)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius = 20
        coverContainerView.layer.cornerRadius = 20
    }

    override func glowContainerView() -> UIView? {
        return coverView
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
            view.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)

            view.layer.shadowOffset = CGSize(width: 0, height: 20)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 20

            self.infoPanelView.alpha = 1
        }
    }
}
