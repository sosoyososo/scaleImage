//
//  SizeListViewController.swift
//  ImageScale
//
//  Created by karsa on 2017/8/29.
//  Copyright © 2017年 karsa. All rights reserved.
//

import Cocoa

class SizeListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    var sizeList : [(ImgScaleUtil.SizeType,Float)] = []
    var startAction : ([(ImgScaleUtil.SizeType,Float)])->() = { _ in
    }
    
    @IBOutlet var table : NSTableView?
    @IBAction func start(_ sender : Any?) {
        startAction(customSizeList())
        dismissViewController(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.dataSource = self
        table?.delegate = self
        table?.reloadData()
    }
    
    func customSizeList() -> [(ImgScaleUtil.SizeType,Float)] {
        var list : [(ImgScaleUtil.SizeType,Float)] = []
        for i in 0...sizeList.count {
            if let view1 = table?.view(atColumn: 0, row: i, makeIfNecessary: false), let view2 = table?.view(atColumn: 1, row: i, makeIfNecessary: false) {
                if let popUpButton = view1.subviews.first as? NSPopUpButton
                    , let textField = view2.subviews.first as? NSTextField {
                    if let type = ImgScaleUtil.SizeType(rawValue: popUpButton.indexOfSelectedItem+1),
                        let size = Float.init(textField.stringValue) {
                        list.append((type, size))
                    }
                }
            }
        }
        return list
    }
    
    
    func typeChanged() {
        updateData()
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        updateData()
        return true
    }
    func updateData() {
        if let view1 = table?.view(atColumn: 0, row: sizeList.count, makeIfNecessary: false), let view2 = table?.view(atColumn: 1, row: sizeList.count, makeIfNecessary: false) {
            if let popUpButton = view1.subviews.first as? NSPopUpButton
                , let textField = view2.subviews.first as? NSTextField {
                if let type = ImgScaleUtil.SizeType(rawValue: popUpButton.indexOfSelectedItem),
                    let size = Float.init(textField.stringValue) {
                    sizeList.append((type, size))
                    table?.reloadData()
                }
            }
        }
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return sizeList.count + 1
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.make(withIdentifier: tableColumn?.identifier ?? "", owner: nil)
        if let tableColumn = tableColumn {
            var (type, size) = (ImgScaleUtil.SizeType.width, Float(0))
            if row < sizeList.count {
                (type, size) = sizeList[row]
            }
            if tableColumn.identifier == "Size" {
                if let textField = view?.subviews.first as? NSTextField {
                    textField.isEnabled = true
                    textField.stringValue = size == 0 ? "" : "\(size)"
                }
            } else if tableColumn.identifier == "Type" {
                if let control = view?.subviews.first as? NSPopUpButton {
                    control.target = self
                    control.action = #selector(typeChanged)
                    if let index = [ImgScaleUtil.SizeType.width, ImgScaleUtil.SizeType.height, ImgScaleUtil.SizeType.scale].index(of: type) {
                        control.selectItem(at: index)
                    }
                }
            }
        }
        return view
    }
}
