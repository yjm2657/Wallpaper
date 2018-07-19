//
//  HomeVC.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/11.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON
//import SwiftyJSON

import SwiftFCXRefresh

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var collectionView:UICollectionView?
    var pageNum:NSInteger = 0
    var headerRefreshView:FCXRefreshHeaderView?
    var footerRefreshView:FCXRefreshFooterView?
    var sortIIdStr:String?
    var optionStr:String = "hot"
    
    var rightBtn:UIButton?
    var sortView:SortView?
    
    
    let CELL_ID = "HomeCollectionCell"
    
    var dataArr:NSMutableArray = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.creatCollectionView()
        self.getDataFromHTTP(page: self.pageNum)
        
        self.setRightBtn()
        self.creatOptionView()
        
    }
    
    func creatOptionView() {
        let optionView:OptionView = OptionView(frame: CGRect(x: kScreenWidth - 10 - 130, y: 64 + 10, width: 130, height: 130))
        optionView.optionViewSelectCloser = { (optionStr) -> () in
            //MARK:热门选项点击
            self.optionStr = optionStr!
            self.collectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            self.pageNum = 0
//            self.dataArr.removeAllObjects()
            self.getDataFromHTTP(page: 0)
        }
        self.view.addSubview(optionView)
        
    }
    
    func setRightBtn() {
        rightBtn = UIButton(type: UIButtonType.custom)
        rightBtn?.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        rightBtn?.setTitleColor(UIColor.black, for: UIControlState.normal)
        rightBtn?.setTitle("分类", for: UIControlState.normal)
        rightBtn?.setTitle("关闭", for: UIControlState.selected)
        rightBtn?.addTarget(self, action: #selector(rightBtnClick), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn!)
    }
    
    @objc func rightBtnClick() {
        
        rightBtn?.isSelected = !((rightBtn?.isSelected)!)
        self.creatSortView()
        self.sortView?.isHidden = !(rightBtn?.isSelected)!
        
    }
    
    func getDataFromHTTP(page:NSInteger, sortIdStr:String? = nil) {
        var para:Dictionary<String, Any>?
        var urlStr:String?
        
        if self.sortIIdStr == nil {
            para = ["skip":self.pageNum, "order":self.optionStr, "limit":10]
            urlStr = "http://service.picasso.adesk.com/v1/vertical/vertical"
        }else{
            para = ["skip":self.pageNum, "order":self.optionStr, "limit":10]
            urlStr = "http://service.picasso.adesk.com/v1/vertical/category/\(self.sortIIdStr ?? "4e4d610cdf714d2966000003")/vertical"
        }
//        print(para)
        Alamofire.request(urlStr!, method: .get, parameters: para).responseString { (response) in
            
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = JSONDeserializer<RootClass>.deserializeFrom(json: jsonString){
                        if(self.pageNum != 0){
                            self.dataArr.addObjects(from: (responseModel.res?.vertical)!)
                        }else{
//                            self.dataArr.removeAllObjects()
                            self.dataArr = NSMutableArray.init(array: (responseModel.res?.vertical)!)
                        }
                        
                        //刷新表格数据
                        DispatchQueue.main.async{
                            self.headerRefreshView?.endRefresh()
                            self.footerRefreshView?.endRefresh()
                            self.collectionView?.reloadData()
                        }

                    }
                    
                }
            }

        }
        
    }
    
    func creatSortView() {
        if self.sortView == nil{
            sortView = SortView(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight - 64))
            sortView?.sortSelectIdCloser = { (idStr) -> () in
                //MARK:分类点击
                self.collectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
                self.sortIIdStr = idStr
                self.pageNum = 0
                self.getDataFromHTTP(page: 0)
                self.rightBtn?.isSelected = false
            }
            self.view.addSubview(sortView!)
        }
    }
    
    func creatCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y:  -44, width: kScreenWidth, height: kScreenHeight + 44), collectionViewLayout: flowLayout)
        collectionView!.backgroundColor = UIColor.white
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
        
        self.view.addSubview(collectionView!)
        
        self.headerRefreshView = collectionView!.addFCXRefreshHeader { [weak self] (refreshHeader) in
            self?.pageNum = 0
            self?.getDataFromHTTP(page: 0)
        }
        
        self.footerRefreshView = collectionView!.addFCXRefreshAutoFooter { [weak self] (refreshFooter) in
            self?.pageNum = (self?.pageNum)! + 10
            self?.getDataFromHTTP(page: (self?.pageNum)!)
        }

        
    }
    
    // MARK:代理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        if (indexPath.row < self.dataArr.count){
            let vertical_a:Vertical = self.dataArr[indexPath.row] as! Vertical
            cell.imageUrlStr = vertical_a.thumb
            cell.model = vertical_a
        }
        return cell
    }
    
    // MARK:间距位置
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(kScreenWidth - 30)/2.0 , height: (kScreenWidth - 20)/2.0/kScreenScale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        [collectionView.deselectItem(at: indexPath, animated: true)]
        
//        let vertical_a:Vertical = self.dataArr[indexPath.row] as! Vertical
//        let detailVC:DetailVC = DetailVC()
//        detailVC.model = vertical_a
//
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(detailVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
