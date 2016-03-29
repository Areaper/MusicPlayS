//
//  MusicCell.swift
//  MusicPlayS
//
//  Created by leon on 16/3/24.
//  Copyright © 2016年 leon. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {
    
    lazy var picImageView = UIImageView()
    lazy var musicNameLabel = UILabel()
    lazy var singerNameLabel = UILabel()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        picImageView.frame = CGRectMake(20, 5, 55, 55)
        contentView.addSubview(picImageView)
        
        musicNameLabel.frame = CGRectMake(CGRectGetMaxX(picImageView.frame) + 10, 10, ScreenWidth - 85, 21)
        musicNameLabel.highlightedTextColor = UIColor.redColor()
        musicNameLabel.textColor = UIColor.whiteColor()
        
        contentView.addSubview(musicNameLabel)
        
        singerNameLabel.frame = CGRectMake(CGRectGetMaxX(picImageView.frame) + 10, CGRectGetMaxY(musicNameLabel.frame) + 3, ScreenWidth - 85, 21)
        singerNameLabel.font = UIFont.systemFontOfSize(13)
        singerNameLabel.highlightedTextColor = UIColor.redColor()
        singerNameLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(singerNameLabel)
    }
    
    func cellWithModel(model: MusicModel) {
        picImageView.sd_setImageWithURL(NSURL(string: model.picUrl))
        musicNameLabel.text = model.name
        singerNameLabel.text = model.singer
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
