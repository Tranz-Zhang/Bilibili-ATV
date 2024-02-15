//
//  FeedsDefines.swift
//  StudyAppleTVUI
//
//  Created by ByteDance on 2024/2/6.
//

import Foundation
import UIKit

enum FeedsCategory: Int {
    case Follow = -1 // 关注
    case Popular = -2 // 热门
    case Recommended = -3 // 推荐
    case Duoga = 1 // 动画(主分区)
//    case Anime        = 13    // 番剧(主分区，废弃)
//    case GuoChuang    = 167   // 国创(主分区，废弃)
    case Music = 3 // 音乐(主分区)
    case Dance = 129 // 舞蹈(主分区)
    case Game = 4 // 游戏(主分区)
    case Knowledge = 36 // 知识(主分区)
    case Technology = 188 // 科技(主分区)
    case Sports = 234 // 运动(主分区)
    case Car = 223 // 汽车(主分区)
    case Life = 160 // 生活(主分区)
    case Food = 211 // 美食(主分区)
    case Animal = 217 // 动物圈(主分区)
    case Kichiku = 119 // 鬼畜(主分区)
    case Fashion = 155 // 时尚(主分区)
    case Entertainment = 5 // 娱乐(主分区)
    case Documentary = 177 // 纪录片(主分区)
    case Movie = 23 // 电影(主分区)
    case TV = 11 // 电视剧(主分区)
}

enum FeedsDisplayStyle {
    case standard /// 标准样式，包含图片，标题，时长
    case detail /// 细节样式，包含图片，标题，时长，tags，作者信息
    case bigPoster /// 大画报样式，更大的尺寸，内容跟detail一致
    case test /// 测试样式
}

/// Feeds流元数据
struct FeedsItem: Hashable {
    var coverURL: URL? /// 封面
    var title: String // 标题
    var videoDuration: Int // 视频时长
    var creatorName: String? // 作者名称
    var creatorAvatarURL: URL? // 作者头像
    var tags: [String] = [] // 视频标签
    var videoSchema: String // 视频播放链接

    private let uniqueHash = Int.random(in: 0...Int.max)

    static func emptyItem() -> FeedsItem {
        return FeedsItem(title: "...", videoDuration: -1, creatorName: "...", videoSchema: "")
    }
}

/// Feeds组
struct FeedsGroup {
    var groupName: String
    var category: FeedsCategory
    var itemList: [FeedsItem]
    var displayStyle: FeedsDisplayStyle = .standard
    private let uniqueHash = Int.random(in: 0...Int.max)

    init(groupName: String, category: FeedsCategory, itemList: [FeedsItem]) {
        self.groupName = groupName
        self.category = category
        self.itemList = itemList
        displayStyle = displayStyleWithCategory(category)
    }

    private func displayStyleWithCategory(_ category: FeedsCategory) -> FeedsDisplayStyle {
        return .standard
    }
}

extension FeedsGroup {
    func sectionLayout() -> NSCollectionLayoutSection? {
        switch displayStyle {
        case .standard:
            return FeedsStandardCell.sectionLayout()
        case .detail:
            return FeedsDetailCell.sectionLayout()
        case .bigPoster:
            return FeedsBigPosterCell.sectionLayout()
        default:
            return TestCollectionCell.sectionLayout()
        }
    }

    func cellIdentifier() -> String {
        switch displayStyle {
        case .standard:
            return FeedsStandardCell.reuseIdentifier
        case .detail:
            return FeedsDetailCell.reuseIdentifier
        case .bigPoster:
            return FeedsBigPosterCell.reuseIdentifier
        default:
            return TestCollectionCell.reuseIdentifier
        }
    }

    static func registerAllCellForCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: FeedsStandardCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: FeedsStandardCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FeedsDetailCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: FeedsDetailCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FeedsBigPosterCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: FeedsBigPosterCell.reuseIdentifier)
        collectionView.register(UINib(nibName: TestCollectionCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: TestCollectionCell.reuseIdentifier)
    }
}

/// protocol for updating date in feeds cell
protocol FeedsCellDataUpdateProtocol {
    func updateData(_ item: FeedsItem)
}
