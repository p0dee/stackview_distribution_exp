//
//  ContentFrameColouredLabel.swift
//  StackViewExample
//
//  Created by Takeshi Tanaka on 2/27/16.
//  Copyright © 2016 Takeshi Tanaka. All rights reserved.
//

import UIKit

class ColouredLabel: UILabel {
    
    typealias DidSelectHandler = (ColouredLabel) -> Void
    
    private var attribute: Dictionary<String, AnyObject>!
    var handler: DidSelectHandler?
    
    private override init(frame: CGRect) {
        attribute = [NSBackgroundColorAttributeName:UIColor.lightGrayColor()]
        super.init(frame: frame)
        self.userInteractionEnabled = true
    }
    
    convenience init(text: String, backgroundColor: UIColor = UIColor.lightGrayColor()) {
        self.init()
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        attribute[NSBackgroundColorAttributeName] = backgroundColor
        self.text = text
        updateLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        set {
            if let newValue = newValue {
                self.attributedText = NSAttributedString(string: newValue, attributes: attribute)
            } else {
                super.text = newValue
            }
        }
        get {
            return super.text
        }
    }
    
    var selected: Bool = false {
        didSet {
            updateLayer()
            if !oldValue && selected {
                self.handler?(self)
            }
        }
    }
    
    private func updateLayer() {
        self.layer.borderWidth = selected ? 5 : 1
        self.layer.borderColor = attribute[NSBackgroundColorAttributeName]?.colorWithAlphaComponent(0.5).CGColor
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if let point = touches.first?.locationInView(self) where CGRectContainsPoint(self.bounds, point) {
            self.selected = true
        }
    }
    
}
