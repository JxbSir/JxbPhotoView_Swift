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
        
        self.view.backgroundColor = UIColor.redColor()
        
        let photo: JxbPhotoView = JxbPhotoView.init(frame: self.view.bounds)
        self.view.addSubview(photo)
        
        let p1: JxbPhotoItem = JxbPhotoItem()
        p1.title = "通过可选绑定让问题变得简单了一些"
        p1.content = "这个函数没有了第一个函数的2个缺陷，但引入了一个新的。你把你要写的代码都放在了所有条件判断中，而不是之后。你可能不会马上意识到这个问题，但是你可以想象在你的代码被执行之前，如果嵌套了好多需要被匹配的条件判断，这会变的多难读懂。"
        p1.imageUrl = "http://c.hiphotos.baidu.com/image/h%3D300/sign=8471e521fafaaf519be387bfbc5594ed/738b4710b912c8fc89a4bbcafb039245d6882165.jpg"
        
        let p2: JxbPhotoItem = JxbPhotoItem()
        p2.title = "这就是guard语句"
        p2.content = "我听说过这个叫保镖模式（Bouncer Pattern），这个模式十分的合理。你要在坏情况进门之前把它们挡出去。这让你每次只考虑一种情况，而不用去搞清楚如何同时将所有的条件判断安排在一起。"
        p2.imageUrl = "http://f.hiphotos.baidu.com/image/h%3D300/sign=6746eb027cf40ad10ae4c1e3672c1151/d439b6003af33a87846ddc20c15c10385343b58c.jpg"
       
        let p3: JxbPhotoItem = JxbPhotoItem()
        p3.title = "发现了什么其他好玩的东西就告诉我"
        p3.content = "对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用对我们来说评判一个新的特性很容易，只要去试一下，看看它对你来说有用没用"
        p3.imageUrl = "http://h.hiphotos.baidu.com/image/h%3D300/sign=74a29f034c36acaf46e090fc4cd98d03/18d8bc3eb13533fa3dc64f14afd3fd1f41345b9c.jpg"
        
        photo.images = [p1,p2,p3]
    }

}

