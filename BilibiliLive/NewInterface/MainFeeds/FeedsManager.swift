//
//  FeedsManager.swift
//  BilibiliLive
//
//  Created by ByteDance on 2024/2/7.
//

import Foundation

/**
 Feeds数据管理器，负责Feeds数据请求，排序，缓存
 关注、推荐、热门、排行榜x10
 */

class FeedsManager {
    private var loadingCategories: [FeedsCategory] = []
    private var feedsGroupList: [FeedsGroup] = []

    static let shared = FeedsManager()
    private init() {
        setupData()
    }

    private func setupData() {
        var list: [FeedsGroup] = []
        for category in allCategories() {
            let groupName = groupNameWithCategory(category)
            let itemList = [FeedsItem.emptyItem(), FeedsItem.emptyItem(), FeedsItem.emptyItem()]
            list.append(FeedsGroup(groupName: groupName, category: category, itemList: itemList))
        }
        feedsGroupList = list
    }

    private func allCategories() -> [FeedsCategory] {
        return [.Food]
    }

    /// Update feeds for specific category
    @MainActor
    func updateFeedsWithCategory(_ category: FeedsCategory) {}

    // Update all category feeds
    @MainActor
    func updateAllFeeds() {
        let allCategories: [FeedsCategory] = allCategories()
        var categorySet = Set<FeedsCategory>(loadingCategories)
        for category in allCategories {
            if !categorySet.contains(category) {
                loadingCategories.append(category)
                categorySet.insert(category)
            }
        }
        tryRequestNextCagetory()
    }

    // MARK: feeds fetch process

    @MainActor
    private func tryRequestNextCagetory() {
        guard let category = loadingCategories.first else { return }
        loadingCategories.removeFirst()
        print("\(self) fetch data for category: \(category)")

        Task {
            // handle data request & process
            let items: [FeedsItem]?
            if category == .Follow {
                items = await fetchFollowFeeds()

            } else if category == .Popular {
                items = await fetchPopularFeeds()

            } else if category == .Recommended {
                items = await fetchRecommendedFeeds()

            } else if category.rawValue > 0 {
                items = await fetchRankingFeeds(category: category)

            } else {
                items = nil
            }

            Task {
                // update feedList
                updateCategoryItems(category: category, items: items)
                // run next request
                tryRequestNextCagetory()
            }
        }
    }

    @MainActor
    private func updateCategoryItems(category: FeedsCategory, items: [FeedsItem]?) {
        print("updateCategoryItems: \(category) - \(items?.count ?? 0)")
        guard let updatedIndex = (feedsGroupList.firstIndex { $0.category == category }) else {
            return
        }

        let group = feedsGroupList[updatedIndex]
        feedsGroupList[updatedIndex] = FeedsGroup(groupName: group.groupName,
                                                  category: group.category,
                                                  itemList: items ?? [])
        // TODO: add update call back !!!
    }

    private func fetchFollowFeeds() async -> [FeedsItem]? {
        print("fetchFollowFeeds")
        do {
            let resultList: [FollowFeedsData] = try await FollowFeedsRequest.send(page: 1)
            var itemList: [FeedsItem] = []
            for feedData in resultList {
                if let info = feedData.feedInfo {
                    itemList.append(FeedsItem(coverURL: URL(string: info.coverURL),
                                              title: info.title,
                                              videoDuration: info.duration,
                                              creatorName: info.upName,
                                              creatorAvatarURL: URL(string: info.upAvatarURL),
                                              videoSchema: ""))

                } else if let feedInfo = feedData.animeInfo {
                    itemList.append(FeedsItem(coverURL: URL(string: feedInfo.coverURL),
                                              title: feedInfo.title,
                                              videoDuration: 0,
                                              creatorName: feedInfo.seasionTitle,
                                              creatorAvatarURL: URL(string: feedInfo.seasonCoverURL),
                                              videoSchema: ""))
                }
            }
            return itemList
        } catch {
            print("Fail to fetchFollowFeeds:\(error)")
            return nil
        }
    }

    private func fetchPopularFeeds() async -> [FeedsItem]? {
        print("fetchPopularFeeds")
        do {
            let feedsList = try await PopularFeedsRequest.send(page: 1)
            guard feedsList.count > 0 else {
                print("fetchPopularFeeds: empty data")
                return nil
            }

            // 标题, 视频描述, 封面URL, aid, 时长, 发布时间, //推荐理由
            var itemList: [FeedsItem] = []
            for info in feedsList {
                itemList.append(FeedsItem(coverURL: URL(string: info.coverURL),
                                          title: info.title,
                                          videoDuration: info.duration,
                                          creatorName: info.upName,
                                          creatorAvatarURL: URL(string: info.upAvatarURL),
                                          tags: [info.recommendReason],
                                          videoSchema: ""))
            }
            return itemList
        } catch {
            print("Fail to fetchFollowFeeds:\(error)")
            return nil
        }
    }

    private func fetchRecommendedFeeds() async -> [FeedsItem]? {
        print("fetchRecommendedFeeds")
        do {
            let feedsList = try await RecommendedFeedsRequest.send(lastIndex: 0)
            // 标题, 封面URL, 播放URL, aid, up主名称, 播放数描述："36.5万观看", 弹幕描述："3998弹幕",  时长描述："15分钟25秒"
            var itemList: [FeedsItem] = []
            for info in feedsList {
                itemList.append(FeedsItem(coverURL: URL(string: info.coverURL),
                                          title: info.title,
                                          videoDuration: info.duration,
                                          creatorName: info.upName,
                                          creatorAvatarURL: URL(string: info.upAvatarURL),
                                          tags: [info.recommendedReason],
                                          videoSchema: ""))
            }
            return itemList
        } catch {
            print("Fail to fetchFollowFeeds:\(error)")
            return nil
        }
    }

    private func fetchRankingFeeds(category: FeedsCategory) async -> [FeedsItem]? {
        print("fetchRankingFeeds: \(category)")
        do {
            let feedsList = try await RankingFeedsRequest.send(category: category.rawValue)
            // 标题, 封面URL, 播放URL, aid, up主名称, 播放数描述："36.5万观看", 弹幕描述："3998弹幕",  时长描述："15分钟25秒"
            var itemList: [FeedsItem] = []
            for info in feedsList {
                itemList.append(FeedsItem(coverURL: URL(string: info.coverURL),
                                          title: info.title,
                                          videoDuration: info.duration,
                                          creatorName: info.upName,
                                          creatorAvatarURL: URL(string: info.upAvatarURL),
                                          tags: [info.shortDescription],
                                          videoSchema: ""))
            }
            return itemList

        } catch {
            print("Fail to fetchRankingFeeds:\(error)")
            return nil
        }
    }

    // MARK: category name & style

    private func groupNameWithCategory(_ category: FeedsCategory) -> String {
        switch category {
        case .Follow: return "关 注"
        case .Popular: return "热 门"
        case .Recommended: return "推 荐"
        case .Duoga: return "动 画"
        case .Music: return "音 乐"
        case .Dance: return "舞 蹈"
        case .Game: return "游 戏"
        case .Knowledge: return "知 识"
        case .Technology: return "科 技"
        case .Sports: return "运 动"
        case .Car: return "汽 车"
        case .Life: return "生 活"
        case .Food: return "美 食"
        case .Animal: return "动物圈"
        case .Kichiku: return "鬼 畜"
        case .Fashion: return "时 尚"
        case .Entertainment: return "娱 乐"
        case .Documentary: return "纪录片"
        case .Movie: return "电 影"
        case .TV: return "电视剧"
        default: return "Unknown"
        }
    }
}
