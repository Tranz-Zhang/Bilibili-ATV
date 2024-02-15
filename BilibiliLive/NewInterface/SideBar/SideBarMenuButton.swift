//
//  SideBarMenuButton.swift
//  StudyAppleTVUI
//
//  Created by Chance Zhang on 2024/1/29.
//

import UIKit

protocol SideBarMenuButtonDelegate: AnyObject {
    func onMenuButtonClicked(_ button: SideBarMenuButton)
    func onMenuButtonFocusChanged(isFocused: Bool, with coordinator: UIFocusAnimationCoordinator)
}

class SideBarMenuButton: UIButton {
    weak var delegate: SideBarMenuButtonDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentHorizontalAlignment = .leading
        addTarget(self, action: #selector(onButtonClicked), for: .primaryActionTriggered)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentHorizontalAlignment = .leading
        addTarget(self, action: #selector(onButtonClicked), for: .primaryActionTriggered)
    }

    static func defaultConfiguration(title: String?, image: UIImage?) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        config.titleAlignment = .leading
        config.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        config.cornerStyle = .large
        config.background.backgroundColor = .clear
        config.baseForegroundColor = .init(white: 0.9, alpha: 1)
        return config
    }

    func setButtonSelected(_ selected: Bool) {
        configuration?.background.backgroundColor = selected ? .black.withAlphaComponent(0.36) : .clear
        setNeedsUpdateConfiguration()
    }

    /// focus event
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        var isFocused = false
        if self == context.nextFocusedView {
            isFocused = true
            superview?.bringSubviewToFront(self)

        } else if self == context.previouslyFocusedView {}

        delegate?.onMenuButtonFocusChanged(isFocused: isFocused, with: coordinator)
    }

    @objc
    private func onButtonClicked() {
        delegate?.onMenuButtonClicked(self)
    }

//    private static func createBackgroundImage(color: UIColor, cornerRadius: CGFloat) -> UIImage {
//        let edge = cornerRadius * 2 + 1
//        let renderer = UIGraphicsImageRenderer(size: CGSizeMake(edge, edge))
//        let image = renderer.image { context in
//            let bezierPath = UIBezierPath(roundedRect: CGRectMake(0, 0, edge, edge), cornerRadius: cornerRadius)
//            color.setFill()
//            bezierPath.fill()
//        }
//        return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius), resizingMode: .stretch)
//    }
}
