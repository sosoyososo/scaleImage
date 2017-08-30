//
//  ImageScaleUtil.swift
//  ImageScale
//
//  Created by karsa on 2017/8/29.
//  Copyright © 2017年 karsa. All rights reserved.
//

import Foundation

class ImgScaleUtil {
    enum SizeType : Int {
        case width = 1
        case height = 2
        case scale = 3
    }
    
    class func scaleImage(with imgUrl : URL, sizeScales : [(SizeType,Float)], finish : ()->()) {
        DispatchQueue.global().async {
            if let resourcePath = Bundle.main.path(forResource: "scaleImage", ofType: "") {
                let task = Process()
                task.launchPath = resourcePath
                var arguments : [String] = [imgUrl.path]
                
                var widthes : [Float] = []
                var heights : [Float] = []
                var scales : [Float] = []
                _=sizeScales.map({ (type, size) -> Void in
                    switch type {
                    case .width :
                        widthes.append(size)
                    case .height :
                        heights.append(size)
                    case .scale:
                        scales.append(size)
                    }
                })
                if widthes.count > 0 {
                    arguments.append("-w")
                    _=widthes.map({ (width) in
                        arguments.append("\(width)")
                    })
                }
                if heights.count > 0 {
                    arguments.append("-h")
                    _=heights.map({ (height) in
                        arguments.append("\(height)")
                    })
                }
                if scales.count > 0 {
                    arguments.append("-s")
                    _=scales.map({ (scale) in
                        arguments.append("\(scale)")
                    })
                }
                
                task.arguments = arguments
                task.launch()
                task.waitUntilExit()
                let status = task.terminationStatus
                print(status)
            }
        }
    }
}
