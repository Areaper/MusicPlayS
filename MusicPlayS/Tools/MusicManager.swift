//
//  MusicManager.swift
//  MusicPlayS
//
//  Created by leon on 16/3/21.
//  Copyright © 2016年 leon. All rights reserved.
//

import UIKit


class MusicManager: NSObject {

    var modelDataArray: NSMutableArray = NSMutableArray()
    
    static let shareManager = MusicManager()

    func requestDataWith(comp: ((Void) -> Void), vc: UIViewController) {
        if isNetWork() {
            vc .showHUDwith("正在加载")
            
            let concurrent = dispatch_queue_create("concurrent1", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent, { () -> Void in
                let url = NSURL(string: "http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist")!
                let arr = NSArray(contentsOfURL: url)!
                for i in 0 ..< arr.count {
                    let model = MusicModel(dic: arr[i] as! [NSObject : AnyObject]) as MusicModel
                    self.modelDataArray.addObject(model)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let musicListVC = vc as! MusicListVC
                        musicListVC.backImageView.sd_setImageWithURL(NSURL(string: self.modelDataArray[0].blurPicUrl))
                        
                        musicListVC.tableView!.reloadData()
                        
                    })
                }
                
            })
            
            vc .hideHUD()
            
            comp()
            
            
        }
        else
        {
            vc .showHUDwhenDisconnectedWith("网络状况不好, 请检查网络")
        }
        
    }
    
    func returnModelNumber() -> Int {
        return modelDataArray.count
    }
    
    func returnModelWithIndexpath(indexPath: Int) -> MusicModel {
        return modelDataArray[indexPath] as! MusicModel
    }
    
    // MARK: netWork
    func isNetWork() -> Bool {
        let reach = Reachability(hostName: "www.baidu.com")
        var isnetwork = Bool()
        switch reach.currentReachabilityStatus() {
        case NotReachable:
            print("没网络")
            isnetwork = false
        case ReachableViaWiFi:
            isnetwork = true
        case ReachableViaWWAN:
            isnetwork = true
        default: break
            
        }
        return isnetwork
    }

}


