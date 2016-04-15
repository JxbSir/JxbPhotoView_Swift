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
    //MARK: Public
    //图片数组
    var photoImages: NSArray?
    //背景颜色，默认黑色
    var backColor: UIColor = UIColor.blackColor()
    //标题（页数）颜色，默认白色
    var titleColor: UIColor = UIColor.whiteColor()
    //正文背景颜色，默认黑色，透明度0.3
    var bodyBack: UIColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    //正文标题颜色，默认白色
    var bodyTitleColor: UIColor = UIColor.whiteColor()
    //正文内容颜色，默认白色
    var bodyContentColor: UIColor = UIColor.whiteColor()
    //标题（页数）字体，默认20
    var titleFont: UIFont = UIFont.systemFontOfSize(20)
    //正文标题字体，默认17
    var bodyTitleFont: UIFont = UIFont.systemFontOfSize(17)
    //正文内容字体，默认13
    var bodyContentFont: UIFont = UIFont.systemFontOfSize(13)
    
    
    //MARK:
    /**
     显示图库，必须执行
     */
    func showLibrary() {
        self.backgroundColor = self.backColor
        self.lblTitle?.textColor = self.titleColor
        self.scDesTitle?.backgroundColor = self.bodyBack
        self.scContent?.backgroundColor = self.bodyBack
        self.lblDesTitle?.textColor = self.bodyTitleColor
        self.lblDesContent?.textColor = self.bodyContentColor
        
        self.lblTitle?.font = self.titleFont
        self.lblDesTitle?.font = self.bodyTitleFont
        self.lblDesContent?.font = self.bodyContentFont
        
        self.pageNow = 0
        self.loadImages(self.pageNow!)
    }
    
    
    //MARK: Private
    private var pageNow: Int?
    private var lblTitle: UILabel?
    private var scrollview: UIScrollView?
    private var picLeft: UIImageView?
    private var scMid: UIScrollView?
    private var picMid: UIImageView?
    private var picRight: UIImageView?

    private var scDesTitle: UIScrollView?
    private var lblDesTitle: UILabel?
    private var scContent: UIScrollView?
    private var lblDesContent: UILabel?
    private var oriTransform: CGAffineTransform?
    private var lastScale: CGFloat?
    
    private var loadView: UIActivityIndicatorView?

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
        //Scroll控制器
        self.scrollview = UIScrollView.init(frame: self.frame)
        self.scrollview?.contentSize = CGSizeMake(self.frame.width * 3, self.frame.height)
        self.scrollview?.pagingEnabled = true
        self.scrollview?.showsVerticalScrollIndicator = true
        self.scrollview?.showsHorizontalScrollIndicator = true
        self.scrollview?.delegate = self
        self.scrollview?.delaysContentTouches = false
        self.addSubview(self.scrollview!)
        
        //标题，页数
        self.lblTitle = UILabel.init(frame: CGRectMake(0, 20, self.frame.width, 30))
        self.lblTitle?.textAlignment = NSTextAlignment.Center
        self.addSubview(self.lblTitle!)
        
        //左图
        self.picLeft = UIImageView.init(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        self.picLeft?.contentMode = UIViewContentMode.ScaleAspectFit
        self.picLeft?.userInteractionEnabled = true
        self.picLeft?.multipleTouchEnabled = true
        self.scrollview?.addSubview(self.picLeft!)
        
        //中图的scrollview，用于缩放
        self.scMid = UIScrollView.init(frame: CGRectMake(self.frame.width, 0, self.frame.width, self.frame.height))
        self.scMid?.showsVerticalScrollIndicator = false
        self.scMid?.showsHorizontalScrollIndicator = false
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
        
        //标题标签
        self.scDesTitle = UIScrollView.init()
        self.addSubview(self.scDesTitle!)
        
        self.lblDesTitle = UILabel.init()
        self.lblDesTitle?.numberOfLines = 0
        self.lblDesTitle?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.scDesTitle?.addSubview(self.lblDesTitle!)
        
        //正文标签
        self.scContent = UIScrollView.init()
        self.addSubview(self.scContent!)
        
        self.lblDesContent = UILabel.init()
        self.lblDesContent?.numberOfLines = 0
        self.lblDesContent?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.scContent?.addSubview(self.lblDesContent!)
        
        //菊花
        self.loadView = UIActivityIndicatorView.init(frame: CGRectMake(0, 0, 32, 32))
        self.loadView?.center = self.center
        self.addSubview(self.loadView!)
        self.loadView?.startAnimating()
        
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
    
    //MARK: 加载图片
    private func loadImages(page: Int) -> Void {
        weak var wSelf: JxbPhotoView? = self
        self.lblTitle?.text = NSString.init(format: "%d / %d", (page+1), (self.photoImages?.count)!) as String
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
        self.loadView?.startAnimating()
        self.loadView?.hidden = false
        let itemCurrent: JxbPhotoItem = (self.photoImages?.objectAtIndex(page))! as! JxbPhotoItem
        let urlCurrent = NSURL(string: itemCurrent.imageUrl!)!
        let resourceCurrent = Resource(downloadURL: urlCurrent, cacheKey: itemCurrent.imageUrl)
        self.picMid!.kf_setImageWithResource(resourceCurrent,placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: {(image: Image?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) -> () in
            wSelf!.loadView?.stopAnimating()
            wSelf!.loadView?.hidden = true
        })
        
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
        self.lblDesTitle?.text = itemCurrent.title
        self.lblDesContent?.text = itemCurrent.content
        
        let s: CGSize = CGSizeMake(self.frame.width - boundsWidth*2, 999)
        let option: NSStringDrawingOptions = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue |
            NSStringDrawingOptions.UsesFontLeading.rawValue | NSStringDrawingOptions.TruncatesLastVisibleLine.rawValue, NSStringDrawingOptions.self)
        var height: CGFloat = 5
        
        if itemCurrent.content == nil {
            self.scContent?.hidden = true
        }
        else {
            self.scContent?.hidden = false
            let rContent: CGRect = NSString(string: itemCurrent.content!).boundingRectWithSize(s, options: option, attributes: [NSFontAttributeName:(self.lblDesContent?.font)!], context: nil)
            self.lblDesContent?.frame = CGRectMake(boundsWidth, height, rContent.width, rContent.height)
            height = height + rContent.height + 10
        }
        
        if (height > maxHeight) {
            self.scContent?.frame = CGRectMake(0, self.frame.height - maxHeight, self.frame.width, maxHeight)
        } else {
            self.scContent?.frame = CGRectMake(0, self.frame.height - height, self.frame.width, height)
        }
        self.scContent?.contentSize = CGSizeMake(self.frame.width, height)
        
        if itemCurrent.title == nil {
            self.scDesTitle?.hidden = true
        }
        else {
            self.scDesTitle?.hidden = false
            let rTitle: CGRect = NSString(string: itemCurrent.title!).boundingRectWithSize(s, options: option, attributes: [NSFontAttributeName:(self.lblDesTitle?.font)!], context: nil)
            self.lblDesTitle?.frame = CGRectMake(boundsWidth, 5, rTitle.width, rTitle.height)
            self.scDesTitle?.frame = CGRectMake(0, (self.scContent?.frame.origin.y)! - rTitle.height - 10, self.frame.width, rTitle.height+10)
        }
        
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
            self.scMid?.contentSize = CGSizeMake(self.frame.width, self.frame.height)
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
