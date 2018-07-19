//
//  DetailVC.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/26.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import HandyJSON

class DetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var model:Vertical?
    
    var commentRe:CommentRe?
    
    
    var tableView:UITableView?
    var bgImageView:UIImageView?
    var showCommentBtn:UIButton?
    var downloadBtn:UIButton?
    
    var perImage:UIImage?
    
    
    var isShowNav:Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.creatBgImageView()
        
        self.getComment()
        
        self.creatDownLoadBtn()
//        self.creatTableView()
        
    }
    
    func creatDownLoadBtn() {
        downloadBtn = UIButton(frame: CGRect(x: kScreenWidth - 50, y: kScreenHeight - 90, width: 40, height: 40))
        downloadBtn?.layer.cornerRadius = 8.0
        downloadBtn?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        downloadBtn?.setImage(UIImage(named: "download"), for: UIControlState.normal)
        downloadBtn?.addTarget(self, action: #selector(downloadBtnClick(_ :)), for:UIControlEvents.touchUpInside)
        self.view.addSubview(downloadBtn!)
    }
    
    @objc func downloadBtnClick(_ button:UIButton) {
        
        let actVC:UIActivityViewController = UIActivityViewController(activityItems: [self.bgImageView?.image as Any], applicationActivities: nil)
        self.present(actVC, animated: true, completion: nil)
    
    }
    
    func creatShowBtn() {
        showCommentBtn = UIButton(frame: CGRect(x: 0, y: kScreenHeight - 40, width: kScreenWidth, height: 40))
        showCommentBtn?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        showCommentBtn?.setTitle("看评论", for: UIControlState.normal)
        showCommentBtn?.setTitleColor(UIColor.black, for: UIControlState.normal)
        showCommentBtn?.addTarget(self, action: #selector(showCommentBtnClick(_:)), for: UIControlEvents.touchUpInside)
//        showCommentBtn?.alpha = 0
        self.view.addSubview(showCommentBtn!)
    }
    
    @objc func showCommentBtnClick(_ button:UIButton) {
        self.animationWithTableView(isShowForTableView: 1)
//        showCommentBtn?.alpha = 0.0
    }
    
    func creatBgImageView() {
        
        bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        bgImageView?.isUserInteractionEnabled = true
//        bgImageView?.kf.setImage(with: URL(string: (model?.preview)!))
        SwiftNotice.wait()
        bgImageView?.kf.setImage(with: URL(string: (model?.img)!), placeholder: self.perImage, options: [.transition(.fade(0.2))], progressBlock: { (d, a) in
            
        }, completionHandler: { (image, err, cache, URL) in
            SwiftNotice.clear()
        })
        
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(tapped(_:)))
        bgImageView?.addGestureRecognizer(tapGes)
        
        self.view.addSubview(bgImageView!)
    }
    
    @objc func tapped(_ button:UIButton) {
        self.navigationController?.setNavigationBarHidden(isShowNav, animated: true)
        isShowNav = !isShowNav
    }
    
    func creatTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight/2.0), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        tableView?.register(UINib(nibName: "DetailCell_0", bundle: nil), forCellReuseIdentifier: "DetailCell_0")
        tableView?.estimatedRowHeight = 300
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.tableFooterView = UIView()
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedForTableView(_:)))
        tableView?.addGestureRecognizer(tapGes)
        self.view.addSubview(tableView!)
        
    }
    
    @objc func tappedForTableView(_ button:UIButton) {
        self.animationWithTableView(isShowForTableView: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (commentRe?.comment.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DetailCell_0 = tableView.dequeueReusableCell(withIdentifier: "DetailCell_0", for: indexPath) as! DetailCell_0
        let comment:Comment = (commentRe?.comment[indexPath.row])!
        cell.commentModel = comment
//        cell.slec
        return cell
    }
    
    //MARK: 网络请求-获取评论
    func getComment() {
        let idStr:String = (model?.id)!
        
        let urlStr:String = "http://service.picasso.adesk.com/v2/vertical/vertical/\(idStr)/comment"
        
        Alamofire.request(urlStr, method: .get).responseString { (response) in
            if response.result.isSuccess{
                if let jsonStr = response.result.value {
                    if let responseModel = JSONDeserializer<CommentRootClass>.deserializeFrom(json:jsonStr){
                        if responseModel.res.comment.count != 0{
                            self.commentRe = responseModel.res
                            self.creatTableView()
//                            self.animationWithTableView(isShowForTableView: 1)
                            self.creatShowBtn()
                        }
                    }
                }
                 
            }
        }
    }
    
    //MARK: 动画效果
    func animationWithTableView(isShowForTableView:CGFloat) {
        
        UIView.animate(withDuration: 0.3) {
            self.tableView?.frame = CGRect(x: 0, y: kScreenHeight/2.0*isShowForTableView, width: kScreenWidth, height: kScreenHeight/2.0)
            if isShowForTableView == 1 {
                self.showCommentBtn?.alpha = 0
                self.downloadBtn?.alpha = 0
            }else {
                self.showCommentBtn?.alpha = 1
                self.downloadBtn?.alpha = 1
            }
        }
    }

}
