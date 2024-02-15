//
//  RecommendedFeedsRequest.swift
//  BilibiliLive
//
//  Created by ByteDance on 2024/2/12.
//

import Foundation
import SwiftyJSON

class RecommendedFeedsRequest {
    static func send(lastIndex: Int) async throws -> [RecommendedFeedsInfo] {
        /// Request
        let jsonResult = try await ApiRequest.requestJSON("https://app.bilibili.com/x/v2/feed/index", parameters: ["idx": "\(lastIndex)", "flush": "0", "column": "4", "device": "pad", "pull": lastIndex == 0 ? "1" : "0"])

        guard let items = jsonResult["data"]["items"].array else {
            throw RequestError.statusFail(code: -1, message: "Fail to get json for key: data.items")
        }

        var resultList: [RecommendedFeedsInfo] = []
        for jsonObj in items {
            let item = RecommendedFeedsInfo(title: jsonObj["title"].stringValue,
                                            coverURL: jsonObj["cover"].stringValue,
                                            aid: jsonObj["args"]["aid"].intValue,
                                            duration: jsonObj["player_args"]["duration"].intValue,
                                            upName: jsonObj["mask"]["avatar"]["text"].stringValue,
                                            upAvatarURL: jsonObj["mask"]["avatar"]["cover"].stringValue,
                                            videoURL: jsonObj["uri"].stringValue,
                                            recommendedReason: jsonObj["top_rcmd_reason"].stringValue)
            resultList.append(item)
        }
        return resultList
    }
}

/// 推荐视频信息
struct RecommendedFeedsInfo {
    let title: String // 标题
    let coverURL: String // 封面URL
    let aid: Int // aid
    let duration: Int // 时长描述："15分钟25秒"
    let upName: String // up主名称
    let upAvatarURL: String // up主头像
    let videoURL: String // 播放URL
    let recommendedReason: String // 推荐理由
}

/*
 {
   "ttl": 1,
   "code": 0,
   "data": {
     "items": [
       {
         "cover_left_text_1": "4:43",
         "title": "高速公路上最危险的8个地方，经过时要条件反射般警惕，小心驾驶",
         "uri": "bilibili:\/\/video\/789001610?cid=1283467602&player_height=1080&player_preload=%7B%22cid%22%3A1283467602%2C%22expire_time%22%3A1707755494%2C%22file_info%22%3A%7B%2216%22%3A%5B%7B%22timelength%22%3A282355%2C%22filesize%22%3A14405192%7D%5D%2C%2264%22%3A%5B%7B%22timelength%22%3A282286%2C%22filesize%22%3A70175218%7D%5D%7D%2C%22support_quality%22%3Anull%2C%22support_formats%22%3Anull%2C%22support_description%22%3Anull%2C%22quality%22%3A16%2C%22url%22%3A%22http%3A%2F%2F157.148.134.3%2Fupgcxcode%2F02%2F76%2F1283467602%2F1283467602-1-16.mp4%3Fe%3Dig8euxZM2rNcNbRVhwdVhwdlhWdVhwdVhoNvNC8BqJIzNbfqXBvEuENvNC8aNEVEtEvE9IMvXBvE2ENvNCImNEVEIj0Y2J_aug859r1qXg8gNEVE5XREto8z5JZC2X2gkX5L5F1eTX1jkXlsTXHeux_f2o859IB_%5Cu0026uipk%3D5%5Cu0026nbs%3D1%5Cu0026deadline%3D1707759094%5Cu0026gen%3Dplayurlv2%5Cu0026os%3Dbcache%5Cu0026oi%3D3706946532%5Cu0026trid%3D00001a8a1e8423294535828f54e49c1d5f06U%5Cu0026mid%3D2662763%5Cu0026platform%3Diphone%5Cu0026upsig%3D5f936fe855ed3aeef4d13ab4200f3577%5Cu0026uparams%3De%2Cuipk%2Cnbs%2Cdeadline%2Cgen%2Cos%2Coi%2Ctrid%2Cmid%2Cplatform%5Cu0026cdnid%3D73401%5Cu0026bvc%3Dvod%5Cu0026nettype%3D0%5Cu0026orderid%3D0%2C3%5Cu0026buvid%3D%5Cu0026build%3D0%5Cu0026f%3DU_0_0%5Cu0026bw%3D51082%5Cu0026logo%3D80000000%22%2C%22video_codecid%22%3A7%2C%22video_project%22%3Atrue%2C%22fnver%22%3A0%2C%22fnval%22%3A0%7D&player_rotate=0&player_width=1920&report_flow_data=%7B%22flow_card_type%22%3A%22av%22%2C%22flow_source%22%3A%22merge_tag_longterm%22%7D&trackid=all_49.router-pegasus-1418617-5588fd6bcb-ft26t.1707751893856.215",
         "mask": {
           "avatar": {
             "up_id": 698396117,
             "event": "up_click",
             "uri": "bilibili:\/\/space\/698396117",
             "cover": "https:\/\/i2.hdslb.com\/bfs\/face\/b4011848490a7aaed0e56ed83f48f8994de5a8da.jpg",
             "text": "老萧说车",
             "event_v2": "up-click"
           },
           "button": {
             "event": "up_follow",
             "type": 2,
             "text": "+ 关注",
             "event_v2": "up-follow",
             "param": "698396117"
           }
         },
         "three_point": {
           "dislike_reasons": [
             {
               "id": 4,
               "toast": "将减少相似内容推荐",
               "name": "UP主:老萧说车"
             },
             {
               "id": 2,
               "toast": "将减少相似内容推荐",
               "name": "分区:汽车知识科普"
             },
             {
               "id": 12,
               "toast": "将减少相似内容推荐",
               "name": "此类内容过多"
             },
             {
               "id": 13,
               "toast": "将减少相似内容推荐",
               "name": "推荐过"
             },
             {
               "id": 1,
               "toast": "将减少相似内容推荐",
               "name": "不感兴趣"
             }
           ],
           "watch_later": 1,
           "feedbacks": [
             {
               "toast": "将优化首页此类内容",
               "id": 1,
               "name": "恐怖血腥"
             },
             {
               "toast": "将优化首页此类内容",
               "id": 2,
               "name": "色情低俗"
             },
             {
               "toast": "将优化首页此类内容",
               "id": 3,
               "name": "封面恶心"
             },
             {
               "toast": "将优化首页此类内容",
               "id": 4,
               "name": "标题党\/封面党"
             }
           ]
         },
         "cover_left_text_3": "154弹幕",
         "top_rcmd_reason": "9千点赞",
         "args": {
           "aid": 789001610,
           "rname": "汽车知识科普",
           "up_id": 698396117,
           "rid": 258,
           "up_name": "老萧说车"
         },
         "can_play": 1,
         "three_point_v2": [
           {
             "type": "watch_later",
             "icon": "https:\/\/i0.hdslb.com\/bfs\/activity-plat\/static\/ce06d65bc0a8d8aa2a463747ce2a4752\/NyPAqcn0QF.png",
             "title": "添加至稍后再看"
           },
           {
             "title": "反馈",
             "reasons": [
               {
                 "toast": "将优化首页此类内容",
                 "id": 1,
                 "name": "恐怖血腥"
               },
               {
                 "toast": "将优化首页此类内容",
                 "id": 2,
                 "name": "色情低俗"
               },
               {
                 "toast": "将优化首页此类内容",
                 "id": 3,
                 "name": "封面恶心"
               },
               {
                 "toast": "将优化首页此类内容",
                 "id": 4,
                 "name": "标题党\/封面党"
               }
             ],
             "type": "feedback",
             "subtitle": "(选择后将优化首页此类内容)"
           },
           {
             "title": "我不想看",
             "reasons": [
               {
                 "toast": "将减少相似内容推荐",
                 "id": 4,
                 "name": "UP主:老萧说车"
               },
               {
                 "toast": "将减少相似内容推荐",
                 "id": 2,
                 "name": "分区:汽车知识科普"
               },
               {
                 "toast": "将减少相似内容推荐",
                 "id": 12,
                 "name": "此类内容过多"
               },
               {
                 "toast": "将减少相似内容推荐",
                 "id": 13,
                 "name": "推荐过"
               },
               {
                 "toast": "将减少相似内容推荐",
                 "id": 1,
                 "name": "不感兴趣"
               }
             ],
             "type": "dislike",
             "subtitle": "(选择后将减少相似内容推荐)"
           }
         ],
         "param": "789001610",
         "bvid": "BV18C4y1f7NX",
         "track_id": "all_49.router-pegasus-1418617-5588fd6bcb-ft26t.1707751893856.215",
         "report_flow_data": "{\"flow_card_type\":\"av\",\"flow_source\":\"merge_tag_longterm\"}",
         "card_goto": "av",
         "desc": "老萧说车 · 2023年9月29日",
         "goto": "av",
         "idx": 1707751909,
         "top_rcmd_reason_style": {
           "border_color": "#FFFB9E60",
           "text_color": "#FFFFFFFF",
           "text": "9千点赞",
           "bg_style": 1,
           "text_color_night": "#E5E5E5",
           "bg_color": "#FFFB9E60",
           "border_color_night": "#BC7A4F",
           "bg_color_night": "#BC7A4F"
         },
         "avatar": {
           "event_v2": "up-click",
           "cover": "https:\/\/i2.hdslb.com\/bfs\/face\/b4011848490a7aaed0e56ed83f48f8994de5a8da.jpg",
           "uri": "bilibili:\/\/space\/698396117",
           "up_id": 698396117,
           "event": "up_click"
         },
         "cover": "http:\/\/i1.hdslb.com\/bfs\/archive\/57abfaaa16ba246635fa745c2dd8dd0725df4368.jpg",
         "cover_left_text_2": "14.3万观看",
         "card_type": "large_cover_v1",
         "player_args": {
           "duration": 283,
           "cid": 1283467602,
           "aid": 789001610,
           "type": "av"
         }
       },
        ...
 }
 */
