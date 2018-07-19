//
//  pch.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/11.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit

import Kingfisher
import HandyJSON
import Alamofire

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenScale = kScreenWidth/kScreenHeight

class Tools: NSObject {
    //MARK: - 查找顶层控制器、
    /// 获取顶层控制器 根据window
    class func getTopVC() -> (UIViewController?) {
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindowLevelNormal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindowLevelNormal{
                    window = windowTemp
                    break
                }
            }
        }
        
        let vc = window?.rootViewController
        return getTopVC(withCurrentVC: vc)
    }
    
    ///根据控制器获取 顶层控制器
    class func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
        
        if VC == nil {
            print("🌶： 找不到顶层控制器")
            return nil
        }
        
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getTopVC(withCurrentVC: presentVC)
        }
        else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        }
        else {
            // 返回顶控制器
            return VC
        }
    }
}





