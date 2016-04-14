//
//  JxbPhotoView.swift
//  JxbPhotoView
//
//  Created by Peter on 16/4/14.
//  Copyright © 2016年 Peter. All rights reserved.
//

import UIKit
import Kingfisher

let boundsWidth: CGFloat = 16.0
let maxHeight: CGFloat = 160

class JxbPhotoView: UIControl, UIScrollViewDelegate {

    //private
    private var pageNow: Int?
    private var scrollview: UIScrollView?
    private var picLeft: UIImageView?
    private var scMid: UIScrollView?
    private var picMid: UIImageView?
    private var picRight: UIImageView?
    private var photoImages: NSArray?
    private var scContent: UIScrollView?
    private var lblTitle: UILabel?
    private var lblContent: UILabel?
    private var oriTransform: CGAffineTransform?
    private var lastScale: CGFloat?
    
    //public
    var images: NSArray? {
        set {
            self.photoImages = newValue
            self.imagesSetter()
        }
        get {
            return self.photoImages!
        }
    }
    
    //MARK: 初始化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    //MARK: 初始化UI
    private func initUI() {
        self.backgroundColor = UIColor.blackColor()
        
        //Scroll控制器
        self.scrollview = UIScrollView.init(frame: self.frame)
        self.scrollview?.contentSize = CGSizeMake(self.frame.width * 3, self.frame.height)
        self.scrollview?.pagingEnabled = true
        self.scrollview?.showsVerticalScrollIndicator = true
        self.scrollview?.showsHorizontalScrollIndicator = true
        self.scrollview?.delegate = self
        self.scrollview?.delaysContentTouches = false
        self.addSubview(self.scrollview!)
        
        //左图
        self.picLeft = UIImageView.init(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        self.picLeft?.contentMode = UIViewContentMode.ScaleAspectFit
        self.picLeft?.userInteractionEnabled = true
        self.picLeft?.multipleTouchEnabled = true
        self.scrollview?.addSubview(self.picLeft!)
        
        //中图的scrollview，用于缩放
        self.scMid = UIScrollView.init(frame: CGRectMake(self.frame.width, 0, self.frame.width, self.frame.height))
        self.scrollview?.addSubview(self.scMid!)
        
        //中图
        self.picMid = UIImageView.init(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        self.picMid?.contentMode = UIViewContentMode.ScaleAspectFit
        self.picMid?.userInteractionEnabled = true
        self.picMid?.multipleTouchEnabled = true
        self.scMid?.addSubview(self.picMid!)
    
        //右图
        self.picRight = UIImageView.init(frame: CGRectMake(self.frame.width*2, 0, self.frame.width, self.frame.height))
        self.picRight?.contentMode = UIViewContentMode.ScaleAspectFit
        self.picRight?.userInteractionEnabled = true
        self.picRight?.multipleTouchEnabled = true
        self.scrollview?.addSubview(self.picRight!)
        
        self.scContent = UIScrollView.init()
        self.scContent?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        self.addSubview(self.scContent!)
        
        //标题标签
        self.lblTitle = UILabel.init()
        self.lblTitle?.textColor = UIColor.whiteColor()
        self.lblTitle?.font = UIFont.systemFontOfSize(17)
        self.lblTitle?.numberOfLines = 0
        self.lblTitle?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.scContent?.addSubview(self.lblTitle!)
        
        //正文标签
        self.lblContent = UILabel.init()
        self.lblContent?.textColor = UIColor.whiteColor()
        self.lblContent?.font = UIFont.systemFontOfSize(13)
        self.lblContent?.numberOfLines = 0
        self.lblContent?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.scContent?.addSubview(self.lblContent!)
        
        let picRec: UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(scaleAction))
        self.picMid?.addGestureRecognizer(picRec)
        
        self.oriTransform = self.picMid?.transform
    }
    
    //MARK: 图片缩放
    func scaleAction(x:UIPinchGestureRecognizer) -> Void {
        if x.state == UIGestureRecognizerState.Began {
            self.lastScale = 1.0
        }
        else if x.state == UIGestureRecognizerState.Ended {
            if self.picMid?.transform.a < 1 {
                let wSelf: JxbPhotoView = self
                UIView.animateWithDuration(0.35, animations:{
                    ()-> Void in
                    wSelf.picMid?.transform = wSelf.oriTransform!
                })
            }
        }
        let scale: CGFloat = 1.0 - (self.lastScale! - x.scale)
        let curTransform: CGAffineTransform = (self.picMid?.transform)!
        let newTransform: CGAffineTransform = CGAffineTransformScale(curTransform, scale, scale)
        self.picMid?.transform = newTransform
        self.picMid?.frame.origin.x = 0
        self.scMid?.contentSize = (self.picMid?.frame.size)!
        self.scMid?.contentOffset = CGPointMake((self.scMid!.contentSize.width - (self.scMid?.frame.size.width)!) / 2, 0)
        self.lastScale = x.scale
    }
    
    //MARK: Images的setter
    private func imagesSetter() {
        self.pageNow = 0
        self.loadImages(self.pageNow!)
    }
    
    //MARK: 加载图片
    private func loadImages(page: Int) -> Void {
        //加载左图
        var leftIndex = page - 1
        if leftIndex < 0 {
            leftIndex = (self.photoImages?.count)! - 1
        }
        let itemLeft: JxbPhotoItem = (self.photoImages?.objectAtIndex(leftIndex))! as! JxbPhotoItem
        let urlLeft = NSURL(string: itemLeft.imageUrl!)!
        let resourceLeft = Resource(downloadURL: urlLeft, cacheKey: itemLeft.imageUrl)
        self.picLeft!.kf_setImageWithResource(resourceLeft)
        
        //加载中图
        let itemCurrent: JxbPhotoItem = (self.photoImages?.objectAtIndex(page))! as! JxbPhotoItem
        let urlCurrent = NSURL(string: itemCurrent.imageUrl!)!
        let resourceCurrent = Resource(downloadURL: urlCurrent, cacheKey: itemCurrent.imageUrl)
        self.picMid!.kf_setImageWithResource(resourceCurrent)
        
        //加载右图
        var rightIndex = page + 1
        if rightIndex >= self.photoImages?.count {
            rightIndex = 0
        }
        let itemRight: JxbPhotoItem = (self.photoImages?.objectAtIndex(rightIndex))! as! JxbPhotoItem
        let urlRight = NSURL(string: itemRight.imageUrl!)!
        let resourceRight = Resource(downloadURL: urlRight, cacheKey: itemRight.imageUrl)
        self.picRight!.kf_setImageWithResource(resourceRight)
        
        //处理标题与内容
        self.lblTitle?.text = itemCurrent.title
        self.lblContent?.text = itemCurrent.content
        
        let s: CGSize = CGSizeMake(self.frame.width - boundsWidth*2, 999)
        let option: NSStringDrawingOptions = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue |
            NSStringDrawingOptions.UsesFontLeading.rawValue | NSStringDrawingOptions.TruncatesLastVisibleLine.rawValue, NSStringDrawingOptions.self)
        var height: CGFloat = 10.0
        if itemCurrent.title == nil {
            self.lblTitle?.hidden = true
        }
        else {
            self.lblTitle?.hidden = false
            let rTitle: CGRect = NSString(string: itemCurrent.title!).boundingRectWithSize(s, options: option, attributes: [NSFontAttributeName:(self.lblTitle?.font)!], context: nil)
            height = height + rTitle.height + 10
            self.lblTitle?.frame = CGRectMake(boundsWidth, 10, rTitle.width, rTitle.height)
        }
        
        if itemCurrent.content == nil {
            self.lblContent?.hidden = true
        }
        else {
            self.lblContent?.hidden = false
            let rContent: CGRect = NSString(string: itemCurrent.content!).boundingRectWithSize(s, options: option, attributes: [NSFontAttributeName:(self.lblContent?.font)!], context: nil)
            self.lblContent?.frame = CGRectMake(boundsWidth, height, rContent.width, rContent.height)
            height = height + rContent.height + 10
        }
        
        if (height > maxHeight) {
            self.scContent?.frame = CGRectMake(0, self.frame.height - maxHeight, self.frame.width, maxHeight)
        } else {
            self.scContent?.frame = CGRectMake(0, self.frame.height - height, self.frame.width, height)
        }
        self.scContent?.contentSize = CGSizeMake(self.frame.width, height)
        
        self.scrollview?.scrollRectToVisible(CGRectMake(self.frame.width, 0, self.frame.width, self.frame.height), animated: false)
    }
    

    //MARK: ScrollView Delegate
    @objc func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if self.photoImages?.count == 0 {
            return
        }
        let x: CGFloat = scrollView.contentOffset.x
        let p: Int = Int(x) / Int(self.frame.width)
        if p == 1 {
            //do nothing
        } else {
            self.picMid?.transform = self.oriTransform!
            self.picMid?.frame.origin.x = 0
            self.scMid?.contentSize = (self.picMid?.frame.size)!
            if p == 0 {
                self.pageNow = self.pageNow! - 1
                if self.pageNow < 0 {
                    self.pageNow = (self.photoImages?.count)! - 1
                }
            }
            else if p == 2 {
                self.pageNow = self.pageNow! + 1
                if self.pageNow >= (self.photoImages?.count)! {
                    self.pageNow = 0
                }
            }
            self.loadImages(self.pageNow!)
        }
        
    }
    
}
