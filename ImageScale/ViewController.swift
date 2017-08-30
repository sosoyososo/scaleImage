//
//  ViewController.swift
//  ImageScale
//
//  Created by karsa on 2017/8/29.
//  Copyright © 2017年 karsa. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    private var sizeList : [(ImgScaleUtil.SizeType,Float)] = [(.width, 40),
                                                              (.width, 60),
                                                              (.width, 58),
                                                              (.width, 87),
                                                              (.width, 80),
                                                              (.width, 120),
                                                              (.width, 180),
                                                              (.width, 20),
                                                              (.width, 29),
                                                              (.width, 76),
                                                              (.width, 152),
                                                              (.width, 167)]
    
    
    @IBOutlet var imgView : NSImageView?
    var imageURL : URL? = nil {
        didSet {
            if let imageURL = imageURL {
                if let image = NSImage.init(contentsOf: imageURL) {
                    self.imgView?.image = image
                }
            }
        }
    }
    var url : URL? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        imgView?.unregisterDraggedTypes()
        (view as? ImagesDropDestenationView)?.register(forDraggedTypes: [NSURLPboardType])
        (view as? ImagesDropDestenationView)?.dropAction = { [unowned self] (urls) in
            self.imageURL = urls.first as URL?
        }
    }
    
   @IBAction  func showSizeList(_ sender : Any? = nil) {
        if let _ = imageURL {
            let storyBoard = NSStoryboard.init(name: "Main", bundle: nil)
            if let controller = storyBoard.instantiateController(withIdentifier: "SizeListViewController") as? SizeListViewController {
                controller.sizeList = sizeList
                controller.startAction = { [unowned self] (sizeList) in
                    if let imageURL = self.imageURL {
                        ImgScaleUtil.scaleImage(with: imageURL, sizeScales: sizeList, finish: {
                        })
                    }
                }
                presentViewControllerAsSheet(controller)
            }
        }
    }
    
    
    
    @IBAction func start(_ sender : Any? = nil) {
        if let imageURL = self.imageURL {
            ImgScaleUtil.scaleImage(with: imageURL, sizeScales: sizeList, finish: {
            })
        }
    }
}

class ImagesDropDestenationView : NSView {
    var dropAction : (([NSURL])->())?
    private var isReceivingDrag : Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(rect:bounds)
            path.lineWidth = 5
            path.stroke()
        }
    }

    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isReceivingDrag = true
        return NSDragOperation.copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        if let urls = draggingInfo.draggingPasteboard().readObjects(forClasses: [NSURL.self], options: [NSPasteboardURLReadingContentsConformToTypesKey:NSImage.imageTypes()]) as? [NSURL]{
            dropAction?(urls)
        }
        return true
    }
}
