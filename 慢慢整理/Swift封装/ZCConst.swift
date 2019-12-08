//
//  ZCConst.swift
//  CustomFont
//
//  Created by yixin on 2017/9/7.
//  Copyright © 2017年 YYG. All rights reserved.
//

import UIKit


let currentVersion = Double(UIDevice.current.systemVersion)

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}
