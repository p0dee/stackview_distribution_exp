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
        attribute = [NSBackgroundColorAttributeName : UIColor.lightGray]
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    convenience init(text: String, backgroundColor: UIColor = UIColor.lightGray) {
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
        self.layer.borderColor = attribute[NSBackgroundColorAttributeName]?.withAlphaComponent(0.5).cgColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let point = touches.first?.location(in: self), self.bounds.contains(point) {
            self.selected = true
        }
    }
    
}
