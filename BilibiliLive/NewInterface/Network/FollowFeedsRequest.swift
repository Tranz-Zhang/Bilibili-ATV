//
//  FollowFeedsRequest.swift
//  BilibiliLive
//
//  Created by ByteDance on 2024/2/10.
//

import Foundation
import SwiftyJSON

class FollowFeedsRequest {
    static func send(page: Int) async throws -> [FollowFeedsData] {
//        return try await WebRequest.request(url: "https://api.bilibili.com/x/web-feed/feed", parameters: ["ps": 30, "pn": page])

        let jsonResult: JSON = try await WebRequest.request(url: "https://api.bilibili.com/x/web-feed/feed", parameters: ["ps": 30, "pn": page])
        guard let list = jsonResult.array else {
            throw RequestError.statusFail(code: -1, message: "Fail to get json for key: data.list")
        }

        var resultList: [FollowFeedsData] = []
        for jsonObj: JSON in list {
            if jsonObj["archive"].type != .null {
                let info = FollowFeedsInfo(title: jsonObj["archive"]["title"].stringValue,
                                           coverURL: jsonObj["archive"]["pic"].stringValue,
                                           firstFrameURL: jsonObj["archive"]["first_frame"].stringValue,
                                           aid: jsonObj["archive"]["aid"].intValue,
                                           duration: jsonObj["archive"]["duration"].intValue,
                                           publishDate: jsonObj["archive"]["pubdate"].intValue,
                                           upName: jsonObj["archive"]["owner"]["name"].stringValue,
                                           upAvatarURL: jsonObj["archive"]["owner"]["face"].stringValue,
                                           viewCount: jsonObj["archive"]["stat"]["view"].intValue,
                                           danmakuCount: jsonObj["archive"]["stat"]["danmaku"].intValue,
                                           replayCount: jsonObj["archive"]["stat"]["reply"].intValue,
                                           favoriteCount: jsonObj["archive"]["stat"]["favorite"].intValue,
                                           coinCount: jsonObj["archive"]["stat"]["coin"].intValue,
                                           shareCount: jsonObj["archive"]["stat"]["share"].intValue,
                                           likeCount: jsonObj["archive"]["stat"]["like"].intValue)
                resultList.append(FollowFeedsData(feedInfo: info, animeInfo: nil))

            } else if jsonObj["bangumi"].type != .null {
                let info = FollowAnimeInfo(title: jsonObj["bangumi"]["new_ep"]["index_title"].stringValue,
                                           coverURL: jsonObj["bangumi"]["new_ep"]["cover"].stringValue,
                                           index: jsonObj["bangumi"]["new_ep"]["index"].stringValue,
                                           episodeId: jsonObj["bangumi"]["new_ep"]["episode_id"].intValue,
                                           danmakuCount: jsonObj["bangumi"]["new_ep"]["dm"].int,
                                           playCount: jsonObj["bangumi"]["new_ep"]["play"].int,
                                           seasionTitle: jsonObj["bangumi"]["title"].stringValue,
                                           seasonId: jsonObj["bangumi"]["season_id"].intValue,
                                           seasonCoverURL: jsonObj["bangumi"]["cover"].stringValue)
                resultList.append(FollowFeedsData(feedInfo: nil, animeInfo: info))
            }
        }
        return resultList
    }
}

struct FollowFeedsData {
    let feedInfo: FollowFeedsInfo?
    let animeInfo: FollowAnimeInfo?
}

/// 热门视频信息
struct FollowFeedsInfo {
    let title: String // 标题
    let coverURL: String // 封面URL
    let firstFrameURL: String? // 首帧画面URL
    let aid: Int // aid
    let duration: Int // 时长
    let publishDate: Int // 发布时间
    let upName: String // up主名称
    let upAvatarURL: String // up主头像
    // 统计信息
    let viewCount: Int
    let danmakuCount: Int
    let replayCount: Int
    let favoriteCount: Int
    let coinCount: Int
    let shareCount: Int
    let likeCount: Int
}

struct FollowAnimeInfo {
    let title: String
    let coverURL: String
    let index: String
    let episodeId: Int
    let danmakuCount: Int?
    let playCount: Int?

    let seasionTitle: String // 标题
    let seasonId: Int // 季度ID
    let seasonCoverURL: String // 季度封面
}

/**
 {
     "code": 0,
     "message": "0",
     "ttl": 1,
     "data": [
         {
             "type": 0,
             "archive": {
                 "aid": 1600626287,
                 "videos": 1,
                 "tid": 76,
                 "tname": "美食制作",
                 "copyright": 1,
                 "pic": "http://i1.hdslb.com/bfs/archive/5da77fb89bf9eef303b8b089dbf74472ba86cbfc.jpg",
                 "title": "大鱼大肉吃多了，新年糖水来润一润，阿胶银耳牛奶糖水，祝大家生活甜甜蜜蜜好滋润",
                 "pubdate": 1707976998,
                 "ctime": 1707976998,
                 "desc": "-",
                 "state": 0,
                 "attribute": 8405120,
                 "duration": 62,
                 "mission_id": 1714614,
                 "rights": {
                     "bp": 0,
                     "elec": 0,
                     "download": 0,
                     "movie": 0,
                     "pay": 0,
                     "hd5": 0,
                     "no_reprint": 1,
                     "autoplay": 1,
                     "ugc_pay": 0,
                     "is_cooperation": 0,
                     "ugc_pay_preview": 0,
                     "no_background": 0,
                     "arc_pay": 0,
                     "pay_free_watch": 0
                 },
                 "owner": {
                     "mid": 701203022,
                     "name": "小喵粑粑",
                     "face": "https://i2.hdslb.com/bfs/face/671af63a0a43c840a92dd41f7654a559aee85048.jpg"
                 },
                 "stat": {
                     "aid": 1600626287,
                     "view": 3649,
                     "danmaku": 0,
                     "reply": 16,
                     "favorite": 55,
                     "coin": 13,
                     "share": 8,
                     "now_rank": 0,
                     "his_rank": 0,
                     "like": 314,
                     "dislike": 0,
                     "vt": 2927,
                     "vv": 3649
                 },
                 "dynamic": "",
                 "cid": 1440154216,
                 "dimension": {
                     "width": 3840,
                     "height": 2160,
                     "rotate": 0
                 },
                 "attribute_v2": 65536,
                 "short_link_v2": "https://b23.tv/BV1p2421w7Gq",
                 "up_from_v2": 36,
                 "first_frame": "http://i0.hdslb.com/bfs/storyff/n240215sa1qvoyvvmq4m2r1dznfvwhf1_firsti.jpg",
                 "pub_location": "广东"
             },
             "bangumi": null,
             "id": 1600626287,
             "pubdate": 1707976998,
             "fold": null,
             "official_verify": {
                 "role": 1,
                 "title": "bilibili 知名美食UP主",
                 "desc": "",
                 "type": 0
             }
         },
         {
             "type": 1,
             "archive": null,
             "bangumi": {
                 "bgm_type": 1,
                 "cover": "https://i0.hdslb.com/bfs/bangumi/image/051fea9873605c4530543c84ed232be90ebfb72c.png",
                 "new_ep": {
                     "cover": "http://i0.hdslb.com/bfs/archive/f562cab709ace28d68a5d6308364264533ed6d85.png",
                     "dm": 284,
                     "episode_id": 812268,
                     "index": "7",
                     "index_title": "交战开始",
                     "play": 51835
                 },
                 "season_id": 47098,
                 "title": "异修罗",
                 "total_count": 12,
                 "ts": 1707919201
             },
             "id": 47098,
             "pubdate": 1707919201,
             "fold": null
         },
         ...
     ]
 }
 */
