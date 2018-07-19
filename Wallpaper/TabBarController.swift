//
//  TabBarController.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/11.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatVC()
    }
    
    func creatVC(){
        let home = HomeVC()
        let homeNAV = UINavigationController(rootViewController: home)
        home.title = "壁纸"
        homeNAV.tabBarItem.image = UIImage(named: "home")
        
        let mine = MineVC()
        let mineNAV = UINavigationController(rootViewController: mine)
        mine.title = "我的"
        mineNAV.tabBarItem.image = UIImage(named: "mine")
        
        let tabArr = [homeNAV,mineNAV]
        self.viewControllers = tabArr

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
