//
//  SortCell.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/27.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit
import Kingfisher

class SortCell: UICollectionViewCell {
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    var model:SortCategory?{
        didSet{
            self.bgImageView.kf.setImage(with: URL(string: (model?.cover)!))
            
//            self.titleLab.text =  "  \(model?.name ?? "")  "
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.titleLab.layer.cornerRadius = 4.0
    }

}
