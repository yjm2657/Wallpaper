//
//  OptionView.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/28.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit

typealias OptionViewSelectCloser = (_ optionStr : String? ) -> ()

class OptionView: UIView {

    var hotBtn:UIButton?
    var favsBtn:UIButton?
    var newBtn:UIButton?
    var menuBtn:UIButton?
    
    var optionViewSelectCloser: OptionViewSelectCloser?
    
    var isOpen:Bool = false
    
    
    let btnWidth:CGFloat = 50
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.creatBtns()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatBtns() {
        hotBtn = UIButton(type: UIButtonType.custom)
        hotBtn?.frame = CGRect(x: self.bounds.size.width - btnWidth, y: 0, width: btnWidth, height: btnWidth)
        hotBtn?.layer.cornerRadius = 4.0
        hotBtn?.tag = 0
        hotBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        hotBtn?.setTitle("热门", for: UIControlState.normal)
        hotBtn?.setTitleColor(UIColor.black, for: UIControlState.normal)
        hotBtn?.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        hotBtn?.addTarget(self, action: #selector(btnsClick(_ :)), for: UIControlEvents.touchUpInside)
        self.addSubview(hotBtn!)
        
        favsBtn = UIButton(type: UIButtonType.custom)
        favsBtn?.frame = CGRect(x: self.bounds.size.width - btnWidth, y: 0, width: btnWidth, height: btnWidth)
        favsBtn?.tag = 1
        favsBtn?.layer.cornerRadius = 4.0
        favsBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        favsBtn?.setTitle("专辑", for: UIControlState.normal)
        favsBtn?.setTitleColor(UIColor.black, for: UIControlState.normal)
        favsBtn?.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        favsBtn?.addTarget(self, action: #selector(btnsClick(_ :)), for: UIControlEvents.touchUpInside)
        self.addSubview(favsBtn!)
        
        newBtn = UIButton(type: UIButtonType.custom)
        newBtn?.frame = CGRect(x: self.bounds.size.width - btnWidth, y: 0, width: btnWidth, height: btnWidth)
        newBtn?.tag = 2
        newBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        newBtn?.layer.cornerRadius = 4.0
        newBtn?.setTitle("最新", for: UIControlState.normal)
        newBtn?.setTitleColor(UIColor.black, for: UIControlState.normal)
        newBtn?.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        newBtn?.addTarget(self, action: #selector(btnsClick(_ :)), for: UIControlEvents.touchUpInside)
        self.addSubview(newBtn!)
        
        menuBtn = UIButton(type: UIButtonType.custom)
        menuBtn?.frame = CGRect(x: self.bounds.size.width - btnWidth, y: 0, width: btnWidth, height: btnWidth)
        menuBtn?.layer.cornerRadius = 4.0
        menuBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        menuBtn?.setTitle("热门", for: UIControlState.normal)
        menuBtn?.setTitleColor(UIColor.black, for: UIControlState.normal)
        menuBtn?.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        menuBtn?.addTarget(self, action: #selector(menuBtnClick(_ :)), for: UIControlEvents.touchUpInside)
        self.addSubview(menuBtn!)
    }

    @objc func btnsClick(_ button:UIButton) {
        var optionStr:String?
        
        switch button.tag {
        case 0:
            menuBtn?.setTitle("热门", for: UIControlState.normal)
            optionStr = "hot"
            break
        case 1:
            menuBtn?.setTitle("专辑", for: UIControlState.normal)
            optionStr = "favs"
            break
        case 2:
            menuBtn?.setTitle("最新", for: UIControlState.normal)
            optionStr = "new"
            break
        default:
            break
        }
        
        if optionViewSelectCloser != nil {
            optionViewSelectCloser!(optionStr)
        }
        
        self.animationCloseWithBtns()
        self.isOpen = false
        
    }
    
    @objc func menuBtnClick(_ button:UIButton) {
        self.isOpen = !self.isOpen
        if self.isOpen {
            self.animationOpenWithBtns()
        }else{
            self.animationCloseWithBtns()
        }
    }
    
    func animationCloseWithBtns() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 30, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.hotBtn?.frame =  CGRect(x: self.bounds.size.width - self.btnWidth, y: 0, width: self.btnWidth, height: self.btnWidth)
            self.favsBtn?.frame = CGRect(x: self.bounds.size.width - self.btnWidth, y: 0, width: self.btnWidth, height: self.btnWidth)
            self.newBtn?.frame = CGRect(x: self.bounds.size.width - self.btnWidth, y: 0, width: self.btnWidth, height: self.btnWidth)
            
        }) { (isSuccess) in
            
        }
    }
    
    func animationOpenWithBtns() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 30, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.hotBtn?.frame = CGRect(x: 0, y: 0, width: self.btnWidth, height: self.btnWidth)
            self.favsBtn?.frame = CGRect(x: 0, y: self.bounds.size.height - self.btnWidth, width: self.btnWidth, height: self.btnWidth)
            self.newBtn?.frame = CGRect(x: self.bounds.size.width - self.btnWidth, y: self.bounds.size.height - self.btnWidth, width: self.btnWidth, height: self.btnWidth)
            
        }) { (isSuccess) in
            
        }
    }
    
}
