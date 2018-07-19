//
//  HomeCollectionCell.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/11.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit
import Kingfisher


class HomeCollectionCell: UICollectionViewCell {

    var model:Vertical?
    
    @IBAction func btnClick(_ sender: UIButton) {
        
        
        let topVC:UIViewController = Tools.getTopVC()!
        
        let vertical_a:Vertical = model!
        let detailVC:DetailVC = DetailVC()
        detailVC.model = vertical_a
        detailVC.perImage = self.imageView.image
        topVC.hidesBottomBarWhenPushed = true
        topVC.navigationController?.pushViewController(detailVC, animated: true)
        topVC.hidesBottomBarWhenPushed = false
    }
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrlStr: String?{
        didSet{
            self.imageView.kf.setImage(with: URL(string: imageUrlStr!),  options: [.transition(.fade(0.2))])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    

}
