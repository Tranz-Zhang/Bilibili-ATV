//
//  PopularFeedsRequest.swift
//  BilibiliLive
//
//  Created by ByteDance on 2024/2/12.
//

import Foundation
import SwiftyJSON

class PopularFeedsRequest {
    static func send(page: Int) async throws -> [PopularFeedsInfo] {
        let jsonResult: JSON = try await WebRequest.requestJSON(url: "https://api.bilibili.com/x/web-interface/popular", parameters: ["pn": page, "ps": 40])
        guard let list = jsonResult["list"].array else {
            throw RequestError.statusFail(code: -1, message: "Fail to get json for key: data.list")
        }

        var resultList: [PopularFeedsInfo] = []
        for jsonObj in list {
            let item = PopularFeedsInfo(title: jsonObj["title"].stringValue,
                                        description: jsonObj["title"].stringValue,
                                        coverURL: jsonObj["pic"].stringValue,
                                        upName: jsonObj["owner"]["name"].stringValue,
                                        upAvatarURL: jsonObj["owner"]["face"].stringValue,
                                        aid: jsonObj["aid"].intValue,
                                        duration: jsonObj["duration"].intValue,
                                        publishDate: jsonObj["pubdate"].intValue,
                                        recommendReason: jsonObj["rcmd_reason"]["content"].stringValue)
            resultList.append(item)
        }
        return resultList
    }
}

/// 热门视频信息
struct PopularFeedsInfo {
    let title: String // 标题
    let description: String // 视频描述
    let coverURL: String // 封面URL
    let upName: String // up主名称
    let upAvatarURL: String // up主头像
    let aid: Int // aid
    let duration: Int // 时长
    let publishDate: Int // 发布时间
    let recommendReason: String // 推荐理由
}

/*
 {
   "code" : 0,
   "data" : {
     "list" : [
       {
         "pub_location" : "北京",
         "state" : 0,
         "bvid" : "BV1yp421R7E1",
         "up_from_v2" : 28,
         "enable_vt" : 0,
         "tid" : 21,
         "owner" : {
           "name" : "吃花椒的喵酱",
           "face" : "https:\/\/i0.hdslb.com\/bfs\/face\/cb49e8804447945761979822437f76a9eabce318.jpg",
           "mid" : 2026561407
         },
         "rcmd_reason" : {
           "corner_mark" : 0,
           "content" : "很多人点赞"
         },
         "pubdate" : 1707904800,
         "is_ogv" : false,
         "ogv_info" : null,
         "copyright" : 1,
         "desc" : "-",
         "rights" : {
           "no_reprint" : 1,
           "elec" : 0,
           "hd5" : 0,
           "arc_pay" : 0,
           "no_background" : 0,
           "ugc_pay" : 0,
           "bp" : 0,
           "pay" : 0,
           "pay_free_watch" : 0,
           "download" : 0,
           "is_cooperation" : 0,
           "ugc_pay_preview" : 0,
           "movie" : 0,
           "autoplay" : 1
         },
         "dimension" : {
           "width" : 3840,
           "height" : 2160,
           "rotate" : 0
         },
         "cid" : 1439483902,
         "dynamic" : "",
         "duration" : 1027,
         "stat" : {
           "aid" : 1850572111,
           "like" : 34103,
           "vt" : 0,
           "favorite" : 4565,
           "danmaku" : 1428,
           "share" : 1880,
           "now_rank" : 0,
           "vv" : 298509,
           "coin" : 13861,
           "dislike" : 0,
           "his_rank" : 0,
           "view" : 298509,
           "reply" : 2370
         },
         "ctime" : 1707831465,
         "aid" : 1850572111,
         "short_link_v2" : "https:\/\/b23.tv\/BV1yp421R7E1",
         "videos" : 1,
         "season_type" : 0,
         "title" : "【冰冰vlog.014】文昌鸡：我当时害怕极了",
         "ai_rcmd" : null,
         "tname" : "日常",
         "pic" : "http:\/\/i2.hdslb.com\/bfs\/archive\/378edc47097a58cd1e9d33f4fbf65c5106c3ed1f.jpg",
         "first_frame" : "http:\/\/i0.hdslb.com\/bfs\/storyff\/n240214sa32gwv8h5eloaucgkoiv2f3g_firsti.jpg"
       },
       ...
     ],
     "no_more" : false
   },
   "ttl" : 1,
   "message" : "0"
 }

 */
