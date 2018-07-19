//
//  DetailCell_0.swift
//  Wallpaper
//
//  Created by 杨洁茂 on 2018/6/26.
//  Copyright © 2018年 杨洁茂. All rights reserved.
//

import UIKit

class DetailCell_0: UITableViewCell {
    @IBOutlet weak var leftLab: UILabel!
    @IBOutlet weak var rightLab: UILabel!
    
    var commentModel:Comment = Comment(){
        didSet
        {
            self.leftLab.text = commentModel.user.name
            self.rightLab.text = commentModel.content
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
