//
//  MineVC.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/11.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit

import Alamofire
import Parchment
import HandyJSON


class CustomPagingView: PagingView {
    
    override func setupConstraints() {
        // Use our convenience extension to constrain the page view to all
        // of the edges of the super view.
        constrainToEdges(pageView)
    }
}

class CustomPagingViewController: FixedPagingViewController {
    override func loadView() {
        view = CustomPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view)
    }
}


class MineVC: UIViewController {
    
    var sortArr:NSMutableArray?
    var pagingViewController:CustomPagingViewController?
    var getSortBtn:UIButton?
    var vcsArr:NSMutableArray = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "壁纸"
        view.backgroundColor = UIColor.white
        
        getSortBtn = UIButton(type: UIButtonType.custom)
        getSortBtn?.bounds = CGRect(x: 0, y: 0, width: kScreenWidth / 3.0, height: 40)
        getSortBtn?.center = CGPoint(x: kScreenWidth/2.0, y: kScreenHeight/2.0)
        getSortBtn?.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        getSortBtn?.setTitle("获取分类信息", for: .normal)
        getSortBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        getSortBtn?.setTitleColor(UIColor.black, for: .normal)
        getSortBtn?.layer.shadowColor = UIColor.black.cgColor
        getSortBtn?.layer.cornerRadius = 8.0
        getSortBtn?.layer.shadowOffset = CGSize(width: 4, height: 4)
        getSortBtn?.addTarget(self, action: #selector(sortBtnClick), for: .touchUpInside)
        view.addSubview(getSortBtn!)
        
        
        self.getSortInfo()
        
        
    }
    
    @objc func sortBtnClick(){
        
        self.getSortHTTP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func getSortInfo() {
        if (UserDefaults.standard.string(forKey: "LocalSortJsonStr") != nil){
            let jsonStr = UserDefaults.standard.string(forKey: "LocalSortJsonStr")
            
            if let responseModel = JSONDeserializer<SortRootClass>.deserializeFrom(json: jsonStr){
                self.sortArr = NSMutableArray.init(array: responseModel.res.category)
                
                let homeVC_0 = HomeVC()
                let nav_0 = UINavigationController(rootViewController: homeVC_0)
                homeVC_0.title = "精选"
                self.vcsArr.add(nav_0)

                for object in self.sortArr! {
                    let homeVC = HomeVC()
                    let nav = UINavigationController(rootViewController: homeVC)
                    let sortCategory:SortCategory = object as! SortCategory
                    homeVC.sortIIdStr = sortCategory.id
                    homeVC.title = sortCategory.name
                    vcsArr.add(nav)
                }
                
                self.creatPagsVC()
            }
        }else{
            self.getSortHTTP()
        }
        
    }
    
    func creatPagsVC()  {
        self.pagingViewController = CustomPagingViewController(viewControllers: vcsArr as! [UIViewController])
        
        self.pagingViewController?.borderOptions = .hidden
        self.pagingViewController?.menuBackgroundColor = .clear
        self.pagingViewController?.indicatorColor = UIColor(red: 23/255.0, green: 23/255.0, blue: 23/255.0, alpha: 1)
        self.pagingViewController?.textColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1)
        
        self.pagingViewController?.selectedTextColor = UIColor(red: 23/255.0, green: 23/255.0, blue: 23/255.0, alpha: 1)
        
        // Make sure you add the PagingViewController as a child view
        // controller and contrain it to the edges of the view.
        addChildViewController(pagingViewController!)
        view.addSubview((pagingViewController?.view)!)
        view.constrainToEdges((pagingViewController?.view)!)
        pagingViewController?.didMove(toParentViewController: self)
        
        
        navigationItem.titleView = pagingViewController?.collectionView
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationItem.titleView?.frame = CGRect(origin: .zero, size: navigationBar.bounds.size)
        self.pagingViewController?.menuItemSize = .sizeToFit(minWidth: 50, height: navigationBar.bounds.height)
//        self.pagingViewController?.menuItemSize = .fixed(width: 100, height: navigationBar.bounds.height)
    }
    
    //MARK:网络请求
    func getSortHTTP() {
        
        SwiftNotice.wait()
        Alamofire.request("http://service.picasso.adesk.com/v1/vertical/category?adult=false&first=1").responseString { (response) in
            if response.result.isSuccess{
                if let jsonStr = response.result.value{
                    
                    UserDefaults.standard.set(jsonStr, forKey: "LocalSortJsonStr")
                    UserDefaults.standard.synchronize()
                    
                    if let responseModel = JSONDeserializer<SortRootClass>.deserializeFrom(json: jsonStr){
                        self.sortArr = NSMutableArray.init(array: responseModel.res.category)
                        
                        let homeVC_0 = HomeVC()
                        let nav_0 = UINavigationController(rootViewController: homeVC_0)
                        homeVC_0.title = "精选"
                        self.vcsArr.add(nav_0)
                        
                        for object in self.sortArr! {
                            let homeVC = HomeVC()
                            let nav = UINavigationController(rootViewController: homeVC)
                            let sortCategory:SortCategory = object as! SortCategory
                            homeVC.sortIIdStr = sortCategory.id
                            homeVC.title = sortCategory.name
                            self.vcsArr.add(nav)
                        }
                        
                        //刷新表格数据
                        DispatchQueue.main.async{
                            self.creatPagsVC()
                            SwiftNotice.clear()
                        }
                    }else{
                        SwiftNotice.clear()
                        SwiftNotice.showText("数据错误,解析失败")
                    }
                }else{
                    SwiftNotice.clear()
                    SwiftNotice.showText("数据错误,解析失败")
                }
                
            }else{
                SwiftNotice.clear()
                SwiftNotice.showText("请求失败,检查网络设置")
            }
        }
    }
    

}
