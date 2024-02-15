//
//  FeedsSectionHeaderView.swift
//  StudyAppleTVUI
//
//  Created by ByteDance on 2024/2/6.
//

import UIKit

class FeedsSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "FeedsSectionHeaderView.reuseIdentifier"
    static let elementKind = "FeedsSectionHeaderView.elementKind"
    let titleLabel = UILabel()
    private var titleTopConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func adjustTitlePosition(isFocus focus: Bool) {
        titleLabel.textColor = focus ? .white : .lightGray
        titleTopConstraint?.constant = focus ? -20 : 0
        layoutIfNeeded()
    }

    private func setup() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        titleTopConstraint?.isActive = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = .lightGray
    }
}
