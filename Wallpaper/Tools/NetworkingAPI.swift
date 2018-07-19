//
//  NetworkingAPI.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/14.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

//import Foundation
////import Moya
//
////初始化网络请求的provider
//let NetworkingProvider = MoyaProvider<Wallpaper>()
//
////请求分类
//public enum Wallpaper{
//    case list(NSInteger)
//}
//
//
////请求配置
//extension Wallpaper: TargetType {
//    //服务器地址
//    public var baseURL: URL {
//        switch self {
//        case .list(_):
//            return URL(string: "http://service.picasso.adesk.com")!
//        }
//    }
//
//    //各个请求的具体路径
//    public var path: String {
//        switch self {
//        case .list(_):
//            return "/v1/vertical/vertical"
//        }
//    }
//
//    //请求类型
//    public var method: Moya.Method {
//        return .get
//    }
//
//    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
//    public var sampleData: Data {
//        return "{}".data(using: String.Encoding.utf8)!
//    }
//
//    public var task: Task {
//        switch self {
//        case .list(let page):
//            var params: [String: Any] = [:]
//            params["limit"] = 10
//            params["adult"] = false
//            params["fisrt"] = page
//            params["skip"] = 180
//            params["order"] = "hot"
//
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//        }
//    }
//
//    public var headers: [String : String]? {
//        return nil
//    }
//
//    //是否执行Alamofire验证
//    public var validate: Bool {
//        return false
//    }
//
//}

