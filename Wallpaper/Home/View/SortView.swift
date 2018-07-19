//
//  SortView.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/27.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit
import SwiftFCXRefresh
import Alamofire
import HandyJSON

typealias SortSelectIdCloser = (_ selectId : String? ) -> ()


class SortView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView?
    var sortSelectIdCloser:SortSelectIdCloser?
    var headerRefreshView:FCXRefreshHeaderView?
    var dataArr:NSMutableArray = []
    
    
    
    let CELL_ID = "SortCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.creatTitleView()
        
//        self.getSortHTTP()
        self.getLoaclSortInfo()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatTitleView() {
        
        let titleLab:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
        titleLab.font = UIFont.systemFont(ofSize: 15)
        titleLab.textColor = UIColor.black
        titleLab.text = "全部分类"
        titleLab.textAlignment = NSTextAlignment.center
        titleLab.backgroundColor = UIColor.white
        self.addSubview(titleLab)
        
    }
    
    func creatCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 40, width: kScreenWidth, height: self.bounds.size.height - 40), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self;
        self.headerRefreshView = collectionView!.addFCXRefreshHeader { [weak self] (refreshHeader) in
            self?.getSortHTTP()
        }
        collectionView?.register(UINib(nibName: "SortCell", bundle: nil), forCellWithReuseIdentifier: CELL_ID)
        
        
        self.addSubview(collectionView!)
        
    }
    
    // MARK:代理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SortCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! SortCell
        let sortCategory:SortCategory = self.dataArr[indexPath.row] as! SortCategory
        cell.model = sortCategory
        return cell
    }
    
    // MARK:间距位置
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(kScreenWidth - 20)/3.0 , height: (kScreenWidth - 20)/3.0*0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (sortSelectIdCloser != nil) {
            let sortCategory:SortCategory = self.dataArr[indexPath.row] as! SortCategory
            sortSelectIdCloser!(sortCategory.id)
        }
 
        self.isHidden = true
        
    }
    //MARK:获取本地分类信息
    func getLoaclSortInfo() {
        if (UserDefaults.standard.string(forKey: "LocalSortJsonStr") != nil){
            let jsonStr = UserDefaults.standard.string(forKey: "LocalSortJsonStr")
            
            if let responseModel = JSONDeserializer<SortRootClass>.deserializeFrom(json: jsonStr){
                self.dataArr = NSMutableArray.init(array: responseModel.res.category)
                if self.collectionView != nil{
                    self.collectionView?.reloadData()
                }else{
                    self.creatCollectionView()
                }
            }
        }else{
            self.getSortHTTP()
        }
    }
    
    
    //MARK:网络请求
    func getSortHTTP() {
        
        Alamofire.request("http://service.picasso.adesk.com/v1/vertical/category?adult=false&first=1").responseString { (response) in
            if response.result.isSuccess{
                if let jsonStr = response.result.value{
                    
                    UserDefaults.standard.set(jsonStr, forKey: "LocalSortJsonStr")
                    UserDefaults.standard.synchronize()
                    
                    if let responseModel = JSONDeserializer<SortRootClass>.deserializeFrom(json: jsonStr){
                        self.dataArr = NSMutableArray.init(array: responseModel.res.category)
                        
                        //刷新表格数据
                        DispatchQueue.main.async{
                            if self.collectionView != nil{
                                
                                self.headerRefreshView?.endRefresh()
                                self.collectionView?.reloadData()
                            }else{
                                self.creatCollectionView()
                            }
                            
                        }
                    }
                }
                
            }
        }
    }
}
