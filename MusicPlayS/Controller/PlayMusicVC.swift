//
//  PlayMusicVC.swift
//  MusicPlayS
//
//  Created by leon on 16/3/24.
//  Copyright © 2016年 leon. All rights reserved.
//

import UIKit

// 声明 Closure
typealias Block = ((Int) -> Void)

class PlayMusicVC: UIViewController, MusicAudioManagerDelegate, UIScrollViewDelegate {
    
    // MARK: 共有属性
    
    // 当前页面的 model
    var music: MusicModel?
    
    // 当前页面播放歌曲的索引
    var currentIndex: Int?
    
    // MARK: 私有属性
    private var setBtnArray: NSMutableArray! // 存放设置的 button
    
    // 背景图片
    private var backImageView: UIImageView!
    
    // scrollView
    private var scrollView: UIScrollView!
    
    // 毛玻璃
    private var blurView: UIVisualEffectView!
    
    // 回退按钮
    private var backButton: UIButton!
    
    // 旋转的 image
    private var rotateImage: UIImageView!
    
    // pageController
    private var pageControl: UIPageControl!
    
    // 歌词 tableView
    private var lrcTV: UITableView!
    
    // 左时间进度 label
    private var leftTimeLabel: UILabel!
    
    // 右时间进度 label
    private var rightTimeLabel: UILabel!
    
    // 标题 label
    private var titleLabel: UILabel!
    
    // 歌手 label
    private var singerLabel: UILabel!
    
    // 时间 slider
    private var timeSlider: UISlider!
    
    // 播放控制按钮
    private var lastSongBtn: UIButton!
    private var playBtn: UIButton!
    private var nextBtn: UIButton!
    
    // 音量 slider
    private var soundSlider: UISlider!
    
    // MARK: life circle 
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicAudioManager.shareManager.delegate = self
        drawButton()
        drawUI()
        addUI()
        reloadData()
    }
    
    
    
    func audioPlayWithProgress(progress: Float) {
        
    }
    
    func audioPlayEndTime() {
        
    }
    
    func drawButton() {
        setBtnArray = NSMutableArray()
        let normalPicName = ["loop", "shuffle", "singleloop", "music"]
        let space = (ScreenWidth - 40 - 25 * 4) / 3
        for i in 0 ..< 4 {
            let setBtn = UIButton(type: .System)
            setBtn.backgroundColor = UIColor.clearColor()
            setBtn.setImage(UIImage(named: normalPicName[i])!, forState: .Normal)
            let highName = NSString.localizedStringWithFormat("%@-s", normalPicName[i])
            setBtn.setImage(UIImage(named: highName as String)!, forState: .Selected)
            setBtn.frame = CGRectMake(20 + 25 * CGFloat(i) + space * CGFloat(i), ScreenHeight - 45, 25, 25)
            setBtn.backgroundColor = UIColor.clearColor()
            setBtn.tintColor = UIColor.blackColor()
            setBtn.addTarget(self, action: #selector(PlayMusicVC.SetBtnTapHandle(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(setBtn)
            self.setBtnArray!.addObject(setBtn)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: delegatemethod
    
    // MARK: private method
    
    func drawUI() {
        // 背景图片
        self.backImageView = UIImageView(frame: self.view.bounds)
        let blurPicUrl = NSURL(string: (self.music?.blurPicUrl)!)
        backImageView!.sd_setImageWithURL(blurPicUrl)
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight / 9 * 4))
        scrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0)
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        // 毛玻璃
        self.blurView = UIVisualEffectView(frame: CGRectMake(0, ScreenHeight / 9 * 4, ScreenWidth, ScreenHeight / 9 * 5))
        blurView.effect = UIBlurEffect(style: .Light)
        
        // 回退 button
        self.backButton = UIButton(type: .System)
        backButton.frame = CGRectMake(20, 20, 30, 30)
        backButton.setImage(UIImage(named: "arrowdown"), forState: .Normal)
        backButton.layer.cornerRadius = 30 / 2
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.tintColor = UIColor.blackColor()
        backButton.addTarget(self, action: #selector(PlayMusicVC.backButtonTapHandler(_:)), forControlEvents: .TouchUpInside)
        
        // 旋转图片
        self.rotateImage = UIImageView(frame: CGRectMake((ScreenWidth - (ScreenHeight / 9 * 4 - 80)) / 2, 40, ScreenHeight / 9 * 4 - 80, ScreenHeight / 9 * 4 - 80))
        rotateImage.backgroundColor = UIColor.redColor()
        rotateImage.layer.cornerRadius = (ScreenHeight / 9 * 4 - 80) / 2
        rotateImage.clipsToBounds = true
        rotateImage.layer.borderColor = UIColor.lightGrayColor().CGColor
        rotateImage.layer.borderWidth = 1.5
        let rotateImageUrl = NSURL(string: (self.music?.picUrl)!)
        rotateImage.sd_setImageWithURL(rotateImageUrl)
        
        // pageControl
        pageControl = UIPageControl(frame: CGRectMake(0, ScreenHeight / 9 * 4 - 30, ScreenWidth, 25))
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.addTarget(self, action: #selector(PlayMusicVC.pageControlValueChange), forControlEvents: .ValueChanged)
        
        // 歌词 tableview
        lrcTV = UITableView(frame: CGRectMake(ScreenWidth, 70, ScreenWidth, ScreenHeight / 9 * 4 - 100))
        lrcTV.separatorStyle = .None
        lrcTV.backgroundColor = UIColor.clearColor()
//        lrcTV.delegate = self
//        lrcTV.dataSource = self
        
        // 左右时间进度 label
        leftTimeLabel = UILabel(frame: CGRectMake(0, 30, 70, 20))
        leftTimeLabel.backgroundColor = UIColor.clearColor()
        leftTimeLabel.text = "0:0"
        leftTimeLabel.textAlignment = .Center
        leftTimeLabel.textColor = UIColor.blackColor()
        leftTimeLabel.font = UIFont.systemFontOfSize(12)
        
        rightTimeLabel = UILabel(frame: CGRectMake(ScreenWidth - 70, 30, 70, 20))
        rightTimeLabel.backgroundColor = UIColor.clearColor()
        rightTimeLabel.textAlignment = .Center
        rightTimeLabel.textColor = UIColor.blackColor()
        rightTimeLabel.font = UIFont.systemFontOfSize(12)
        let time = Int(self.music!.duration)
        let leftT = time! / 1000
        let leftMinute = leftT / 60
        let leftSecond = leftT % 60
        rightTimeLabel.text = "-" + String(leftMinute) + ":" + String(leftSecond)
        
        // 标题 label
        titleLabel = UILabel(frame: CGRectMake((ScreenWidth - 260) / 2, 70, 260, 30))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = music!.name
        
        // 歌手 label
        singerLabel = UILabel(frame: CGRectMake((ScreenWidth - 200) / 2, 110, 200, 30))
        singerLabel.textAlignment = .Center
        singerLabel.textColor = UIColor.blackColor()
        singerLabel.font = UIFont.systemFontOfSize(14)
        singerLabel.text = music!.singer
        
        // 时间进度 slider
        timeSlider = UISlider(frame: CGRectMake(0, ScreenHeight / 9 * 4 - 10, ScreenWidth, 20))
        timeSlider.backgroundColor = UIColor.clearColor()
        timeSlider.setThumbImage(UIImage(named: "thumb"), forState: .Normal)
        timeSlider.minimumTrackTintColor = UIColor.redColor()
        timeSlider.value = 0
        timeSlider.addTarget(self, action: #selector(PlayMusicVC.timeSliderValueChangeHandle(_:)), forControlEvents: .ValueChanged)
        timeSlider.maximumValue = Float(music!.duration)! / 1000
        
        // 播放控制按钮
        lastSongBtn = UIButton(type: .System)
        lastSongBtn.frame = CGRectMake(45, 150, 30, 20)
        lastSongBtn.backgroundColor = UIColor.clearColor()
        lastSongBtn.setImage(UIImage(named: "rewind.png")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        lastSongBtn.addTarget(self, action: #selector(PlayMusicVC.forwardBtnTapHandle(_:)), forControlEvents: .TouchUpInside)
        
        playBtn = UIButton(type: .System)
        playBtn.frame = CGRectMake((ScreenWidth - 20) / 2, 150, 20, 20)
        playBtn.setImage(UIImage(named: "pause")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        playBtn.addTarget(self, action: #selector(PlayMusicVC.playBtnTapHandle(_:)), forControlEvents: .TouchUpInside)
        
        nextBtn = UIButton(type: .System)
        nextBtn.frame = CGRectMake(ScreenWidth - 75, 150, 30, 20)
        nextBtn.setImage(UIImage(named: "forward")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        nextBtn.addTarget(self, action: #selector(PlayMusicVC.nextBtnTapHandle(_:)), forControlEvents: .TouchUpInside)
        
        // 音量 slider
        soundSlider = UISlider(frame: CGRectMake(30, 190, ScreenWidth - 60, 10))
        soundSlider.backgroundColor = UIColor.clearColor()
        soundSlider.setThumbImage(UIImage(named: "volumn_slider_thumb"), forState: .Normal)
        soundSlider.minimumTrackTintColor = UIColor.blackColor()
        soundSlider.maximumTrackTintColor = UIColor.blackColor()
        soundSlider.maximumValueImage = UIImage(named: "volumehigh")
        soundSlider.minimumValueImage = UIImage(named: "volumelow")
        soundSlider.maximumValue = 1
        soundSlider.minimumValue = 0
        soundSlider.addTarget(self, action: #selector(PlayMusicVC.soundSliderValueChangeHandle(_:)), forControlEvents: .ValueChanged)
        soundSlider.value = 0.5
        self.soundSliderValueChangeHandle(soundSlider)
        
    }
    
    func addUI() {
        self.view.addSubview(backImageView!)
        self.view.addSubview(scrollView)
        self.view.addSubview(blurView!)
        self.view.addSubview(backButton)
        self.scrollView.addSubview(self.rotateImage)
        self.view.addSubview(pageControl)
        self.scrollView.addSubview(self.lrcTV)
        blurView.addSubview(leftTimeLabel)
        blurView.addSubview(rightTimeLabel)
        blurView.addSubview(titleLabel)
        blurView.addSubview(singerLabel)
        self.view.addSubview(self.timeSlider)
        self.blurView.addSubview(self.lastSongBtn)
        blurView.addSubview(playBtn)
        blurView.addSubview(nextBtn)
        blurView.addSubview(soundSlider)
        
        // 将 button 到上面
        for i in 0..<self.setBtnArray!.count {
            self.view.bringSubviewToFront(self.setBtnArray![i] as! UIView)
        }
        
    }
    
    func reloadData() {
        
        let mm = MusicManager.shareManager
        self.music = mm.returnModelWithIndexpath(self.currentIndex!)
        
        MusicAudioManager.shareManager.setMusicAudioWithMusicUrl(self.music!.mp3Url)
        MusicAudioManager.shareManager.playVC = self
        MusicAudioManager.shareManager.play()
        
    }
    
    // MARK: event response
    
    // 回退 button 点击方法
    func backButtonTapHandler(button: UIButton) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 模式选择 button 点击方法
    func SetBtnTapHandle(btn: UIButton) {
        
    }
    
    // pageControl 值改变方法
    func pageControlValueChange() {
        
    }
    
    // 时间进度 slider valueChange
    func timeSliderValueChangeHandle(slider: UISlider) {
        
    }
    
    // 上一首
    func forwardBtnTapHandle(btn: UIButton) {
        
    }
    
    // 播放
    func playBtnTapHandle(btn: UIButton) {
        
    }
    
    // 下一首
    func nextBtnTapHandle(btn: UIButton) {
        
    }
    
    // 音量 slider value change
    func soundSliderValueChangeHandle(slider :UISlider) {
        
    }
}
