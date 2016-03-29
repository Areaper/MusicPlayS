//
//  MusicListVC.swift
//  MusicPlayS
//
//  Created by leon on 16/3/21.
//  Copyright © 2016年 leon. All rights reserved.
//

import UIKit

class MusicListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    internal var tableView: UITableView!
    internal var backImageView: UIImageView!
    
    private var selectIndex: NSInteger?
    
    
    // MARK: lifeCircle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        //
        
    }
    
    override func viewDidLoad() {
        self.title = "音乐播放器"
        backImageView = UIImageView(frame: UIScreen.mainScreen().bounds)
        // 毛玻璃
        let visualView = UIVisualEffectView(frame: UIScreen.mainScreen().bounds)
        visualView.effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        backImageView.addSubview(visualView)
        
        // 设置上边导航 bar 为透明
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        // 使用自定义 button
        let customBtn = UIButton(type: UIButtonType.Custom)
        customBtn.setImage(UIImage(named: "music-s"), forState: UIControlState.Normal)
        customBtn.setImage(UIImage(named: "music-s"), forState: UIControlState.Highlighted)
        customBtn.addTarget(self, action: #selector(MusicListVC.RightBtnTapHandle), forControlEvents: UIControlEvents.TouchUpInside)
        customBtn.frame = CGRectMake(0, 0, 30, 30)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customBtn)
        
        // 设置 tableView
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.size.height - 64), style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.blackColor()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // 背景图片作为 tableView 的背景图片
        tableView.backgroundView = self.backImageView
        
        // 这个属性控制背景是否向四周延伸
        self.edgesForExtendedLayout = UIRectEdge.None
        
        // 下面这句话的作用: 当有导航的时候 00 点 顶着导航 2. 没有导航的时候是顶着屏幕的 00 点
        self.navigationController?.automaticallyAdjustsScrollViewInsets = true
        
        // 不要横线 
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.registerClass(MusicCell.self, forCellReuseIdentifier: "cell")
        
        let manager = MusicManager.shareManager
        manager.requestDataWith({ () -> Void in
            self.tableView.reloadData()
            
            
            }, vc: self)
        
        
        
        
        
    }
    
    // MARK: dataSource delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicManager.shareManager.returnModelNumber()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MusicCell
        
        cell.cellWithModel(MusicManager.shareManager.returnModelWithIndexpath(indexPath.row))
        
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        backImageView.sd_setImageWithURL(NSURL(string: MusicManager.shareManager.returnModelWithIndexpath(indexPath.row).blurPicUrl))
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let playMusicVC = PlayMusicVC()
        let musicManager = MusicManager.shareManager
        playMusicVC.music = musicManager.returnModelWithIndexpath(indexPath.row)
        playMusicVC.currentIndex = indexPath.row
        self.presentViewController(playMusicVC, animated: true, completion: nil)
        
        
    }
    
    
    
    
    // MARK: event response
    func RightBtnTapHandle() -> Void {
        
    }
    
    
    
}
