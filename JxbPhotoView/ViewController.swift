//
//  ViewController.swift
//  JxbPhotoView
//
//  Created by Peter on 16/4/14.
//  Copyright © 2016年 Peter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b: Bool = false
    
        var rect: CGRect = CGRectZero
        
        if (b) {
            rect = self.view.bounds
        }
        else {
            let y: uint = arc4random() % 100 + 50;
            rect = CGRectMake(0, CGFloat(y), self.view.bounds.width, 200)
        }
        
        self.view.backgroundColor = UIColor.redColor()
        
   
        let photo: JxbPhotoView = JxbPhotoView.init(frame: rect)
        self.view.addSubview(photo)
        
        let p1: JxbPhotoItem = JxbPhotoItem()
        p1.title = "通过可选绑定让问题变得简单了一些"
        p1.content = "这个函数没有了第一个函数的2个缺陷，但引入了一个新的。你把你要写的代码都放在了所有条件判断中，而不是之后。你可能不会马上意识到这个问题，但是你可以想象在你的代码被执行之前，如果嵌套了好多需要被匹配的条件判断，这会变的多难读懂。"
        p1.imageUrl = "http://h.hiphotos.baidu.com/image/pic/item/91ef76c6a7efce1b52024a8aa851f3deb48f6541.jpg"
        
        let p2: JxbPhotoItem = JxbPhotoItem()
        p2.title = "这就是guard语句"
        p2.content = "我听说过这个叫保镖模式（Bouncer Pattern），这个模式十分的合理。你要在坏情况进门之前把它们挡出去。这让你每次只考虑一种情况，而不用去搞清楚如何同时将所有的条件判断安排在一起。"
        p2.imageUrl = "http://g.hiphotos.baidu.com/image/pic/item/f3d3572c11dfa9ecfc13ccc066d0f703918fc12c.jpg"
       
        let p3: JxbPhotoItem = JxbPhotoItem()
        p3.title = "发现了什么其他好玩的东西就告诉我"
        p3.content = "对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用"
        p3.imageUrl = "http://h.hiphotos.baidu.com/image/pic/item/a2cc7cd98d1001e9460fd63bbd0e7bec54e797d7.jpg"
        
        photo.photoImages = [p1,p2,p3]
        
        photo.showLibrary(b, page: 0)
    }

}

