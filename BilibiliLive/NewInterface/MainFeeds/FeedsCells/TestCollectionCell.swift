//
//  TestCollectionCell.swift
//  StudyTVDesign
//
//  Created by ByteDance on 2023/11/24.
//

import ParallaxView
import UIKit

class TestCollectionCell: ParallaxCollectionViewCell, FeedsCellDataUpdateProtocol {
    static let reuseIdentifier = "TestCollectionCell.reuseIdentifier"
    static let nibName = "TestCollectionCell"

    @IBOutlet private var testButton: UIButton!

    static func sectionLayout() -> NSCollectionLayoutSection {
        /// create item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        /// create group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(480),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        testButton.setTitleColor(state.isFocused ? .blue : .white, for: .normal)
        backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        setNeedsDisplay()
    }

    func updateData(_ item: FeedsItem) {
        testButton.setTitle(item.title, for: .normal)
    }

    override func setupParallax() {
        cornerRadius = 8

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
        }

        parallaxViewActions.setupFocusedState = { view in
            view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)

            view.layer.shadowOffset = CGSize(width: 0, height: 20)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 20
        }
    }

    override var canBecomeFocused: Bool {
        return true
    }
}
