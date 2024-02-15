//
//  RootViewController.swift
//  StudyAppleTVUI
//
//  Created by ByteDance on 2024/2/5.
//

import UIKit

class RootViewController: UIViewController, SideBarViewDelegate {
    private weak var sideBarView: SideBarView?
    private var viewControllers: [UIViewController]!
    private var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup data source
        let vcSource: [(SideBarItem, UIViewController)] = [
            (SideBarItem(title: "Home", icon: UIImage(systemName: "circle.circle.fill")!), MainFeedsViewController()),
            (SideBarItem(title: "Search", icon: UIImage(systemName: "circle.circle.fill")!), TestViewController()),
            (SideBarItem(title: "Personal", icon: UIImage(systemName: "circle.circle.fill")!), TestViewController()),
            (SideBarItem(title: "Settings", icon: UIImage(systemName: "circle.circle.fill")!), TestViewController()),
        ]

        sideBarView = SideBarView.setupOnView(view, withItems: vcSource.map { $0.0 }, delegate: self)
        viewControllers = vcSource.map { $0.1 }
        showViewControllerAtIndex(0)
    }

    func sideBarViewDidSelectItem(_ sideBarView: SideBarView, _ item: SideBarItem) {
        showViewControllerAtIndex(sideBarView.selectedIndex)
    }

    private func showViewControllerAtIndex(_ index: Int) {
        guard index >= 0 && index < viewControllers.count else {
            return
        }
        let nextVC = viewControllers[index]
        guard nextVC != currentViewController else {
            return
        }

        // ViewController Transition
        let dismissVC = currentViewController
        dismissVC?.willMove(toParent: nil)

        nextVC.view.frame = view.bounds
        nextVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nextVC.view.alpha = 0
        addChild(nextVC)
        view.insertSubview(nextVC.view, at: 0)

        UIView.animate(withDuration: 0.3) {
            nextVC.view.alpha = 1
            dismissVC?.view.alpha = 0

        } completion: { success in
            dismissVC?.view.removeFromSuperview()
            dismissVC?.removeFromParent()

            nextVC.didMove(toParent: self)
            self.currentViewController = nextVC
        }
    }
}
