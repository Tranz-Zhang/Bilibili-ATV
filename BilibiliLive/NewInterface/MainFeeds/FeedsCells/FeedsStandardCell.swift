//
//  FeedsStandardCell.swift
//  StudyAppleTVUI
//
//  Created by ByteDance on 2024/2/6.
//

import UIKit

class FeedsStandardCell: FeedsBaseCell, FeedsCellDataUpdateProtocol {
    static let reuseIdentifier = "FeedsStandardCell.reuseIdentifier"
    static let nibName = "FeedsStandardCell"

    @IBOutlet var coverView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoPanelView: UIView?
    @IBOutlet var durationLabel: UILabel!

    static func sectionLayout() -> NSCollectionLayoutSection {
        /// create item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        /// create group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(540),
                                               heightDimension: .absolute(360))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    func updateData(_ item: FeedsItem) {
        titleLabel.text = item.title
        durationLabel.text = String.durationString(item.videoDuration)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius = 20
        coverView.layer.cornerRadius = 20
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

            self.infoPanelView?.alpha = 0
        }

        parallaxViewActions.setupFocusedState = { view in
            view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)

            view.layer.shadowOffset = CGSize(width: 0, height: 20)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 20

            self.infoPanelView?.alpha = 1
        }
    }
}
