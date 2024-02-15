//
//  RankingFeedsRequest.swift
//  BilibiliLive
//
//  Created by ByteDance on 2024/2/12.
//

import Foundation
import SwiftyJSON

class RankingFeedsRequest {
    static func send(category: Int) async throws -> [RankingFeedsInfo] {
        let jsonResult: JSON = try await WebRequest.requestJSON(url: "https://api.bilibili.com/x/web-interface/ranking/v2", parameters: ["rid": category, "type": "all"])
        guard let list = jsonResult["list"].array else {
            throw RequestError.statusFail(code: -1, message: "Fail to get json for key: data.list")
        }

        var resultList: [RankingFeedsInfo] = []
        for jsonObj in list {
            let item = RankingFeedsInfo(title: jsonObj["title"].stringValue,
                                        description: jsonObj["desc"].stringValue,
                                        shortDescription: jsonObj["tname"].stringValue,
                                        coverURL: jsonObj["pic"].stringValue,
                                        firstFrameURL: jsonObj["first_frame"].string,
                                        aid: jsonObj["aid"].intValue,
                                        duration: jsonObj["duration"].intValue,
                                        publishDate: jsonObj["pubdate"].intValue,
                                        upName: jsonObj["owner"]["name"].stringValue,
                                        upAvatarURL: jsonObj["owner"]["face"].stringValue,
                                        viewCount: jsonObj["stat"]["view"].intValue,
                                        danmakuCount: jsonObj["stat"]["danmaku"].intValue,
                                        replayCount: jsonObj["stat"]["reply"].intValue,
                                        favoriteCount: jsonObj["stat"]["favorite"].intValue,
                                        coinCount: jsonObj["stat"]["coin"].intValue,
                                        shareCount: jsonObj["stat"]["share"].intValue,
                                        likeCount: jsonObj["stat"]["like"].intValue)
            resultList.append(item)
        }
        return resultList
    }
}

/// 分类信息
struct RankingFeedsInfo {
    let title: String // 标题
    let description: String // 视频描述
    let shortDescription: String // 简介
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

//    let upInfo: UpInfo          // Up主
//    let statInfo: StatInfo      // 统计信息

//    enum CodingKeys: String, CodingKey {
//        case title
//        case description = "desc"
//        case shortDescription = "tname"
//        case coverURL = "pic"
//        case firstFrameURL = "first_frame"
//        case aid
//        case duration
//        case publishDate = "pubdate"
//        case upInfo = "owner"
//        case statInfo = "stat"
//    }
//
//    /// Up主信息
//    struct UpInfo: Codable {
//        let name: String
//        let avatarURL: String
//        let mid: Int
//
//        enum CodingKeys: String, CodingKey {
//            case name
//            case avatarURL = "face"
//            case mid
//        }
//    }
//
//    /// 统计信息
//    struct StatInfo: Codable {
//        let viewCount: Int
//        let danmakuCount: Int
//        let replayCount: Int
//        let favoriteCount: Int
//        let coinCount: Int
//        let shareCount: Int
//        let likeCount: Int
//
//        enum CodingKeys: String, CodingKey {
//            case viewCount      = "view"
//            case danmakuCount   = "danmaku"
//            case replayCount    = "reply"
//            case favoriteCount  = "favorite"
//            case coinCount      = "coin"
//            case shareCount     = "share"
//            case likeCount      = "like"
//        }
//    }
//
//    static func == (lhs: RankingFeedsInfo, rhs: RankingFeedsInfo) -> Bool {
//        return lhs.title == rhs.title && lhs.aid == rhs.aid
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(title)
//        hasher.combine(aid)
//    }
}

/*
 {
     "code": 0,
     "message": "0",
     "ttl": 1,
     "data": {
         "note": "根据稿件内容质量、近期的数据综合展示，动态更新",
         "list": [
             {
                 "aid": 1500297154,
                 "videos": 1,
                 "tid": 138,
                 "tname": "搞笑",
                 "copyright": 1,
                 "pic": "http://i2.hdslb.com/bfs/archive/32c0d5e2aa70b99730ab4746ebb87f83ffb44d77.jpg",
                 "title": "急啊急啊急啊",
                 "pubdate": 1707883200,
                 "ctime": 1707397355,
                 "desc": "新年快乐！\n希望观众老爷喜欢这个系列！\n（希望你们喜欢，记得素质三连！：）））））））））））",
                 "state": 0,
                 "duration": 986,
                 "mission_id": 4009753,
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
                     "is_cooperation": 1,
                     "ugc_pay_preview": 0,
                     "no_background": 0,
                     "arc_pay": 0,
                     "pay_free_watch": 0
                 },
                 "owner": {
                     "mid": 5970160,
                     "name": "小潮院长",
                     "face": "https://i1.hdslb.com/bfs/face/834eb0de8d2f470bf03e4ea92831b14f3824c863.jpg"
                 },
                 "stat": {
                     "aid": 1500297154,
                     "view": 3165566,
                     "danmaku": 38396,
                     "reply": 7860,
                     "favorite": 93946,
                     "coin": 188258,
                     "share": 5693,
                     "now_rank": 0,
                     "his_rank": 1,
                     "like": 359873,
                     "dislike": 0,
                     "vt": 0,
                     "vv": 3165566
                 },
                 "dynamic": "急啊急啊急啊",
                 "cid": 1434387778,
                 "dimension": {
                     "width": 1920,
                     "height": 1080,
                     "rotate": 0
                 },
                 "short_link_v2": "https://b23.tv/BV1kU421d7YH",
                 "first_frame": "http://i1.hdslb.com/bfs/storyff/n240208sa9pqld1hgb0hypnipmxe4j2h_firsti.jpg",
                 "pub_location": "上海",
                 "bvid": "BV1kU421d7YH",
                 "score": 0,
                 "others": [
                     {
                         "aid": 1350357561,
                         "videos": 1,
                         "tid": 17,
                         "tname": "单机游戏",
                         "copyright": 1,
                         "pic": "http://i1.hdslb.com/bfs/archive/4b999b3523e32db6b027e3425b4a49fca2aea983.jpg",
                         "title": "2024我的世界拜年纪",
                         "pubdate": 1707530400,
                         "ctime": 1707405367,
                         "desc": "祝大家新年快乐！万事如意！天天开心呀！！\n拜托观众老爷这次三连给上吧！\n真的真的肝爆爆爆爆了！（我的世界拜年纪）",
                         "state": 0,
                         "attribute": 16793728,
                         "duration": 1918,
                         "mission_id": 4010414,
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
                             "is_cooperation": 1,
                             "ugc_pay_preview": 0,
                             "no_background": 0,
                             "arc_pay": 0,
                             "pay_free_watch": 0
                         },
                         "owner": {
                             "mid": 5970160,
                             "name": "小潮院长",
                             "face": "https://i1.hdslb.com/bfs/face/834eb0de8d2f470bf03e4ea92831b14f3824c863.jpg"
                         },
                         "stat": {
                             "aid": 1350357561,
                             "view": 3841199,
                             "danmaku": 169302,
                             "reply": 15046,
                             "favorite": 369800,
                             "coin": 891183,
                             "share": 31324,
                             "now_rank": 0,
                             "his_rank": 1,
                             "like": 685488,
                             "dislike": 0,
                             "vt": 0,
                             "vv": 3841199
                         },
                         "dynamic": "",
                         "cid": 1434513355,
                         "dimension": {
                             "width": 1920,
                             "height": 1080,
                             "rotate": 0
                         },
                         "attribute_v2": 65536,
                         "short_link_v2": "https://b23.tv/BV1AB421z7LS",
                         "first_frame": "http://i0.hdslb.com/bfs/storyff/n240208sa3iqo5c61tnx241rsrtco324_firsti.jpg",
                         "pub_location": "上海",
                         "bvid": "BV1AB421z7LS",
                         "score": 0,
                         "enable_vt": 0
                     }
                 ],
                 "enable_vt": 0
             },
            ...
         ]
     }
 }
 */
