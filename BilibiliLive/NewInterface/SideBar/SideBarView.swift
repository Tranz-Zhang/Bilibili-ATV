//
//  SideBarView.swift
//  StudyAppleTVUI
//
//  Created by Chance Zhang on 2024/1/29.
//

import UIKit

/// Item to define side bar content
struct SideBarItem {
    var title: String
    var icon: UIImage
}

/// CallBack for SideBar Selection
protocol SideBarViewDelegate: AnyObject {
    func sideBarViewDidSelectItem(_ view: SideBarView, _ item: SideBarItem)
}

/**
 SideBarView like Apple TV+, replacement for tabs
 */
class SideBarView: UIView, SideBarMenuButtonDelegate {
    // side bar size
    private static let sideBarLeading = 20.0
    private static let sideBarWidth = 360.0
    private static let sideBarVerticalMargin = 30.0
    private static let sideBarCornerRadius = 35.0

    private var focusGuide: UIFocusGuide?
    private var menuButtons: [SideBarMenuButton] = []
    private var items: [SideBarItem] = []
    var selectedIndex = 0

    @IBOutlet var contentStackView: UIStackView!
    @IBOutlet var boundaryImageView: UIImageView!

    weak var delegate: SideBarViewDelegate?

    static func setupOnView(_ view: UIView, withItems items: [SideBarItem], delegate: SideBarViewDelegate?) -> SideBarView? {
        let nib = UINib(nibName: "SideBarView", bundle: Bundle.main)
        guard let sidebar = nib.instantiate(withOwner: view).first as? SideBarView else {
            return nil
        }
        sidebar.frame = CGRectMake(sideBarLeading, sideBarVerticalMargin, sideBarWidth, view.bounds.size.height - sideBarVerticalMargin * 2)
        sidebar.autoresizingMask = [.flexibleHeight]
        sidebar.layer.cornerRadius = sideBarCornerRadius
        sidebar.alpha = 0.0
        sidebar.backgroundColor = .clear
        sidebar.delegate = delegate
        view.addSubview(sidebar)

        sidebar.setupContentWithItems(items)
        sidebar.setupFocusGuide(onView: view)

        return sidebar
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func awakeFromNib() {
        boundaryImageView.image = createBackgroundBoundaryImage()
    }

    func setupContentWithItems(_ items: [SideBarItem]) {
        var index = 0
        var menuButtons: [SideBarMenuButton] = []
        for item in items {
            let config = SideBarMenuButton.defaultConfiguration(title: item.title, image: item.icon)
            let button = SideBarMenuButton(configuration: config)
            button.setButtonSelected(index == 0)
            button.delegate = self
            button.tag = index
            contentStackView.addArrangedSubview(button)
            button.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 88).isActive = true
            menuButtons.append(button)
            index += 1
        }
        self.menuButtons = menuButtons
        self.items = items
    }

    func setupFocusGuide(onView parentView: UIView) {
        // set side focus guide
        let focusGuide = UIFocusGuide()
        parentView.addLayoutGuide(focusGuide)
        focusGuide.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        focusGuide.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalTo: parentView.heightAnchor).isActive = true
        focusGuide.widthAnchor.constraint(equalToConstant: 1).isActive = true
        focusGuide.preferredFocusEnvironments = [menuButtons.first!]
        self.focusGuide = focusGuide

        // set focus guide inside sidebar
        let topFocusGuide = UIFocusGuide()
        addLayoutGuide(topFocusGuide)
        topFocusGuide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        topFocusGuide.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topFocusGuide.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topFocusGuide.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topFocusGuide.preferredFocusEnvironments = [menuButtons.first!]

        let bottomFocusGuide = UIFocusGuide()
        addLayoutGuide(bottomFocusGuide)
        bottomFocusGuide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomFocusGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomFocusGuide.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomFocusGuide.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomFocusGuide.preferredFocusEnvironments = [menuButtons.last!]
    }

    func onMenuButtonClicked(_ button: SideBarMenuButton) {
        selectedIndex = button.tag
        focusGuide?.preferredFocusEnvironments = []

        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { success in
            for button in self.menuButtons {
                button.setButtonSelected(button.tag == self.selectedIndex)
            }
        }

        let item = items[selectedIndex]
        delegate?.sideBarViewDidSelectItem(self, item)
    }

    func onMenuButtonFocusChanged(isFocused: Bool, with coordinator: UIFocusAnimationCoordinator) {
        var shouldFocus = false
        for button in menuButtons {
            if button.isFocused {
                shouldFocus = true
                break
            }
        }

        var newFrame = frame
        newFrame.origin.x = shouldFocus ? SideBarView.sideBarLeading : -SideBarView.sideBarWidth
        newFrame.size.width = SideBarView.sideBarWidth
        let alpha = shouldFocus ? 1.0 : 0
        coordinator.addCoordinatedAnimations {
            self.frame = newFrame
            self.alpha = alpha
        } completion: {
            self.focusGuide?.preferredFocusEnvironments = [self.menuButtons[self.selectedIndex]]
        }
    }

    private func createBackgroundBoundaryImage() -> UIImage {
        let radius = SideBarView.sideBarCornerRadius
        let edge = radius * 2 + 1
        let renderer = UIGraphicsImageRenderer(size: CGSizeMake(edge, edge))
        let image = renderer.image { context in
            let bezierPath = UIBezierPath(roundedRect: CGRectMake(0, 0, edge, edge), cornerRadius: radius)
            bezierPath.lineWidth = 1
            UIColor(white: 1, alpha: 0.5).setStroke()
            bezierPath.stroke()
        }
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius), resizingMode: .stretch)
    }
}
