//
//  FeedsBaseCell.swift
//  StudyAppleTVUI
//
//  Created by Chance Zhang on 2024/2/7.
//

import ParallaxView
import UIKit

class FeedsBaseCell: UICollectionViewCell, ParallaxableView {
    open var parallaxEffectOptions = ParallaxEffectOptions()
    open var parallaxViewActions = ParallaxViewActions<FeedsBaseCell>()

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        parallaxViewActions.setupUnfocusedState?(self)
    }

    /// Override this method in `FeedsBaseCell` subclass if you would like to provide custom
    /// setup for the `parallaxEffectOptions` and/or `parallaxViewActions`
    open func setupParallax() {}

    /// Override this method in `FeedsBaseCell` subclass if you would like to provide custom glowContainerView
    open func glowContainerView() -> UIView? { return nil }

    func commonInit() {
        layer.shadowOpacity = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shouldRasterize = true

        parallaxEffectOptions.glowContainerView = glowContainerView()
        if parallaxEffectOptions.glowContainerView == nil {
            parallaxEffectOptions.glowContainerView = contentView
        }
        parallaxEffectOptions.parallaxSubviewsContainer = contentView

        parallaxViewActions.setupUnfocusedState = { [weak self] view in
            guard let _self = self else { return }
            view.transform = CGAffineTransform.identity

            view.layer.shadowOffset = CGSize(width: 0, height: _self.bounds.height * 0.015)
            view.layer.shadowRadius = 5
        }

        parallaxViewActions.setupFocusedState = { [weak self] view in
            guard let _self = self else { return }
            view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)

            view.layer.shadowOffset = CGSize(width: 0, height: _self.bounds.height * 0.12)
            view.layer.shadowRadius = 15
        }

        parallaxViewActions.beforeResignFocusAnimation = { $0.layer.zPosition = 0 }
        parallaxViewActions.beforeBecomeFocusedAnimation = { $0.layer.zPosition = 100 }

        setupParallax()
    }

    // MARK: UIResponder

    // Generally, all responders which do custom touch handling should override all four of these methods.
    // If you want to customize animations for press events do not forget to call super.
    override open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        parallaxViewActions.animatePressIn?(self, presses, event)

        super.pressesBegan(presses, with: event)
    }

    override open func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        parallaxViewActions.animatePressOut?(self, presses, event)

        super.pressesCancelled(presses, with: event)
    }

    override open func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        parallaxViewActions.animatePressOut?(self, presses, event)

        super.pressesEnded(presses, with: event)
    }

    override open func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesChanged(presses, with: event)
    }

    override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if self == context.nextFocusedView {
            // Add parallax effect to focused cell
            parallaxViewActions.becomeFocused?(self, context, coordinator)
        } else if self == context.previouslyFocusedView {
            // Remove parallax effect
            parallaxViewActions.resignFocus?(self, context, coordinator)
        }
    }

    override var canBecomeFocused: Bool {
        return true
    }
}

extension FeedsBaseCell {
    static func setupTags(_ tags: [String], toView tagButton: UIButton) {
        let filteredTags = tags.filter { $0.count > 0 }
        guard filteredTags.count > 0 else {
            tagButton.isHidden = true
            return
        }
        tagButton.isHidden = false
        let tagTitle = filteredTags.joined(separator: " | ")
        tagButton.setTitle(tagTitle, for: .normal)
    }
}

extension String {
    static func durationString(_ duration: Int) -> String {
        if duration <= 0 {
            return ""
        }
        let minutes = Int(floor(Double(duration) / 60))
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
