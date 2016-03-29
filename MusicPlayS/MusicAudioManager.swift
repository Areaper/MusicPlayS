//
//  MusicAudioManager.swift
//  MusicPlayS
//
//  Created by leon on 16/3/24.
//  Copyright © 2016年 leon. All rights reserved.
//

import UIKit
import AVFoundation

// 声明枚举
enum MusicRunMode: Int {
    case MusicRunModelListLoop = 0
    case MusicRunModeRandomLoop
    case MusicRunModeSingleLoop
    case MusicRunModeCurrentLoop
}

// 声明代理
protocol MusicAudioManagerDelegate {
    
    func audioPlayWithProgress(progress: Float)
    // 代理方法 自动播放下一首
    func audioPlayEndTime()
    
}


class MusicAudioManager: NSObject {
    // 公共变量
    
    // 对应枚举的属性 用于存储当前点击的 button
    var runModel: MusicRunMode?
    // 音量
    var volume: Float? {
        get {
            return avplayer?.volume
        }
        set {
            avplayer?.volume = volume!
        }
    }
    
    

    
    
    // 判断当前的状态
    var isPlaying: Bool?
    // 代理人
    var delegate: MusicAudioManagerDelegate?
    // 存储当前歌曲的 url
    var currentURL: String?
    // 存储详情页面 VC
    var playVC: PlayMusicVC?
    
    // 私有变量
    
    // 播放器
    private var avplayer: AVPlayer?
    // 定时器
    private var timer: NSTimer?
    
    // 单例
    static var shareManager = MusicAudioManager()
    
    // 根据 url 获取当前歌曲的路径
    func returnSongPathWithURL(url: String) -> String {
        let fm = NSFileManager.defaultManager()
        var libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        libraryPath.appendContentsOf("Songs")
        
        try! fm.createDirectoryAtPath(libraryPath, withIntermediateDirectories: true, attributes: nil)
        
        let s: NSString = libraryPath as NSString
        s.substringFromIndex(60)
        
        libraryPath.appendContentsOf(s as String)
        return libraryPath
    }
    
    // 通过 url 设置音频
    func setMusicAudioWithMusicUrl(musicUrl: String) -> Void {
//        if ((self.avplayer?.currentItem) != nil) {
//            self.avplayer?.currentItem?.removeObserver(self, forKeyPath: "status")
//        }
//        
//        currentURL = musicUrl
//        let fm = NSFileManager.defaultManager()
//        
//        let songPath = self.returnSongPathWithURL(currentURL!)
//        if fm.fileExistsAtPath(songPath) {
//            let url = NSURL(fileURLWithPath: songPath)
//            let asset = AVAsset(URL: url)
//            let item = AVPlayerItem(asset: asset)
//            item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New , context: nil)
//            avplayer?.replaceCurrentItemWithPlayerItem(item)
//            
//            
//        }
//        else {
//            let concurrent: dispatch_queue_t = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT)
//            
//            dispatch_async(concurrent, { () -> Void in
//                let data = NSData(contentsOfURL: NSURL(string: musicUrl)!)
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    fm.createFileAtPath(songPath, contents: data, attributes: nil)
//                    
//                })
//            })
//            
//            let asset = AVAsset(URL: NSURL(string: musicUrl)!)
//            let item = AVPlayerItem(asset: asset)
//            item.addObserver(self, forKeyPath: "status", options: .New, context: nil)
//            
//            self.avplayer?.replaceCurrentItemWithPlayerItem(item)
//            
//
//            
//            
//        }
        
        let asset = AVAsset(URL: NSURL(string: musicUrl)!)
        let item = AVPlayerItem(asset: asset)
        item .addObserver(self, forKeyPath: "status", options: .New, context: nil)
        self.avplayer?.replaceCurrentItemWithPlayerItem(item)
        self.avplayer?.play()
        
    }
    
    // 观察方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let new = change!["new"] as! NSInteger
        switch (new) {
        case 2:
            try! NSFileManager.defaultManager().removeItemAtPath(self.returnSongPathWithURL(self.currentURL!))
            break
        case 0:
            print("avplayeritemstatusfailed")
            break
        case 1:
            play()
             break
        default:
            break
        }
    }
    
    func play() {
        if ((self.timer?.invalidate()) != nil) {
            self.avplayer?.play()
            self.isPlaying = true
            return
        }
        self.avplayer?.play()
        self.isPlaying = true
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.timeHandle), userInfo: nil, repeats: true)
        
    }
    
    func timeHandle() {
        if (self.delegate != nil) {
//            let value = (self.avplayer?.currentTime().value)! as Int64
//            let scale = (self.avplayer?.currentTime().timescale)! as Int32
//            let second = value / scale
            
//            let currentSecond = self.avplayer!.currentTime().value as! Float
            // 计算当前在第几秒  [self updateVideoSlider:currentSecond];

            
//            delegate?.audioPlayWithProgress(currentSecond)
        }
    }
    
    func pause() -> Void {
        self.avplayer?.pause()
        isPlaying = false
        timer?.invalidate()
        timer = nil
        
    }
    
//    func isplayCurrentAudioWithURL(url: NSString) -> Bool {
//        let currentURL: NSString = self.avplayer?.currentItem!.asset
//        
//    }
    
    func seekToTimePlay(time:Float) -> Void {
        avplayer?.seekToTime(CMTimeMakeWithSeconds(time as! Double, self.avplayer!.currentTime().timescale))
        
        
    }
    
//    func returnCurrentTime(_: Void) -> NSInteger {
//        let second = self.avplayer?.currentTime().value / self.avplayer?.currentTime().timescale
//        return second
//    }
    
    
    
    
    
    // 初始化方法
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicAudioManager.audioEndHandle), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
        
    }
    
    func audioEndHandle() {
        if self.delegate != nil {
            delegate?.audioPlayEndTime()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
