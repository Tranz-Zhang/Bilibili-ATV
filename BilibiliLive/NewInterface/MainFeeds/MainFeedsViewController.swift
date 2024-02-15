//
//  MainFeedsViewController.swift
//  StudyAppleTVUI
//
//  Created by Chance Zhang on 2024/1/29.
//

import UIKit

// TODO:
/// UI
/// |
/// Data
/// - thumbnail
/// - title
/// - ownerName
/// - ownerAvatar
/// - tags
/// - duration?
/// - displayStyle
/// - videoSchema?
///
/// UI样式
///     - 关注
///     - 推荐
///     - 热门
///     - 分类排行榜
/// 数据结构
/// 数据源Manager

class MainFeedsViewController: UIViewController, UICollectionViewDelegate {
    enum Section {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<String, FeedsItem>!
    private var collectionView: UICollectionView!
    private var lastFocusedCell: UICollectionViewCell?
    private var currentFocusedIndexPath: IndexPath?
    private var feedsGroupList: [FeedsGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup collection view
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView

        // setup data source
        FeedsGroup.registerAllCellForCollectionView(self.collectionView)
        setupDataSource(collectionView)
        setupSectionHeader(dataSource, collectionView)

        // update data source
        feedsGroupList = createTestDataSource()
        updateDataSource(feedsGroupList)
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let group = self.feedsGroupList[sectionIndex]
            let section = group.sectionLayout()

            // setup section header layout
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(60))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: FeedsSectionHeaderView.elementKind,
                alignment: .top
            )
            section?.boundarySupplementaryItems = [sectionHeader]

            return section
        }
    }

    private func setupDataSource(_ collectionView: UICollectionView) {
        // setup Cell
        dataSource = UICollectionViewDiffableDataSource<String, FeedsItem>(collectionView: collectionView) { collectionView, indexPath, feedItem in
            let group = self.feedsGroupList[indexPath.section]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: group.cellIdentifier(), for: indexPath)
            if let feedCell = cell as? FeedsCellDataUpdateProtocol {
                feedCell.updateData(feedItem)
            }
            return cell
        }
    }

    private func setupSectionHeader(_ dataSource: UICollectionViewDiffableDataSource<String, FeedsItem>, _ collectionView: UICollectionView) {
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <FeedsSectionHeaderView>(elementKind: FeedsSectionHeaderView.elementKind) {
            (headerView, elementKind, indexPath) in
            let group = self.feedsGroupList[indexPath.section]
            headerView.titleLabel.text = group.groupName
        }

        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, elementKind: String, indexPath: IndexPath) in
            if elementKind == FeedsSectionHeaderView.elementKind {
                let headerView = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)

                // update section header title
                let isHeaderFocused = (self.currentFocusedIndexPath != nil) ? self.currentFocusedIndexPath?.section == indexPath.section : false
                headerView.adjustTitlePosition(isFocus: isHeaderFocused)
                return headerView
            }
            return nil
        }
    }

    private func updateDataSource(_ groups: [FeedsGroup]) {
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<String, FeedsItem>()
        for group in groups {
            snapshot.appendSections([group.groupName])
            snapshot.appendItems(group.itemList)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    //
//    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
//        if context.previouslyFocusedIndexPath != nil &&
//           context.nextFocusedIndexPath == nil {
//            self.lastFocusedCell = collectionView.cellForItem(at:context.previouslyFocusedIndexPath!)
//            print("set last focus index: \(String(describing: context.previouslyFocusedIndexPath))")
//        }
//
//        return true
//    }

//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        if view == self.currentFocusHeaderView {
//            self.currentFocusHeaderView?.adjustTitlePosition(isFocus: true)
//        }
//    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedIndexPath != nil &&
            context.nextFocusedIndexPath == nil
        {
            lastFocusedCell = collectionView.cellForItem(at: context.previouslyFocusedIndexPath!)
            print("set last focus index: \(String(describing: context.previouslyFocusedIndexPath))")
        }
        // TODO: adjust section header label position
        if let indexPath = context.nextFocusedIndexPath {
            let headerView = collectionView.supplementaryView(forElementKind: FeedsSectionHeaderView.elementKind, at: IndexPath(row: 0, section: indexPath.section)) as? FeedsSectionHeaderView
            headerView?.adjustTitlePosition(isFocus: true)
        }
        if let indexPath = context.previouslyFocusedIndexPath {
            let headerView = collectionView.supplementaryView(forElementKind: FeedsSectionHeaderView.elementKind, at: IndexPath(row: 0, section: indexPath.section)) as? FeedsSectionHeaderView
            let shouldFocus = (context.nextFocusedIndexPath != nil) ? context.nextFocusedIndexPath?.section == indexPath.section : false
            headerView?.adjustTitlePosition(isFocus: shouldFocus)
        }
        currentFocusedIndexPath = context.nextFocusedIndexPath
    }

    override open var preferredFocusEnvironments: [UIFocusEnvironment] {
        return (lastFocusedCell != nil) ? [lastFocusedCell!] : []
    }

    private func createTestDataSource() -> [FeedsGroup] {
        var groups: [FeedsGroup] = []
        for sectionIndex in 0...6 {
            var itemList: [FeedsItem] = []
            for cellIndex in 0...20 {
                let item = randomFeedsItem()
                itemList.append(item)
            }

            var style = FeedsDisplayStyle.standard
            if sectionIndex == 0 {
                style = .bigPoster

            } else if sectionIndex < 2 {
                style = .detail
            }

            groups.append(FeedsGroup(groupName: "Section Title \(sectionIndex)", category: .Recommended, itemList: itemList))
        }
        return groups
    }

    private func randomFeedsItem() -> FeedsItem {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var coverURL = URL(string: "https://i0.wp.com/oliverx.link/wp-content/uploads/2023/08/big_buck_bunny_00652.png?fit=1920%2C1080&ssl=1")!
        var randomLength = Int.random(in: 5...100)
        var title = String((0..<randomLength).map { _ in letters.randomElement()! })
        var videoDuration = Int.random(in: 1...10000)

        randomLength = Int.random(in: 1...30)
        var creatorName = String((0..<randomLength).map { _ in letters.randomElement()! })
        var creatorAvatarURL = URL(string: "https://user-images.githubusercontent.com/522079/90506845-e8420580-e122-11ea-82ca-31087fc8486c.png")!
        var tags = [String((0..<3).map { _ in letters.randomElement()! })]
        return FeedsItem(coverURL: coverURL, title: title, videoDuration: videoDuration, creatorName: creatorName, creatorAvatarURL: creatorAvatarURL, tags: tags, videoSchema: "")
    }
}
