//
//  StepperView.swift
//  StackViewExample
//
//  Created by Takeshi Tanaka on 2/28/16.
//  Copyright © 2016 Takeshi Tanaka. All rights reserved.
//

import UIKit

class Stepper: UIControl {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let arrowsView = ArrowsView()
    var value: Int = 0 {
        didSet {
            valueLabel.text = String(value)
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    convenience init(title: String, initialValue: Int = 0) {
        self.init()
        titleLabel.text = title
        updateValue(initialValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        titleLabel.textColor = self.tintColor
        valueLabel.textColor = self.tintColor
    }
    
    private func updateValue(value: Int) {
        self.value = value
    }
    
    private func setupViews() {
        titleLabel.font = UIFont.systemFontOfSize(10)
        titleLabel.textAlignment = .Right
        valueLabel.font = UIFont.boldSystemFontOfSize(24)
        valueLabel.textAlignment = .Right
    }
    
    private func setupLayout() {
        arrowsView.setContentHuggingPriority(251, forAxis: .Horizontal)
        let innerSv = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        innerSv.axis = .Vertical
        let outerSv = UIStackView(arrangedSubviews: [innerSv, arrowsView])
        outerSv.translatesAutoresizingMaskIntoConstraints = false
        outerSv.spacing = 8
        outerSv.axis = .Horizontal
        self.addSubview(outerSv)
        //constraints
        var cstrs = [NSLayoutConstraint]()
        cstrs += outerSv.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor)
        cstrs += outerSv.topAnchor.constraintEqualToAnchor(self.topAnchor)
        cstrs += outerSv.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor)
        cstrs += outerSv.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor)
        NSLayoutConstraint.activateConstraints(cstrs)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let point = touches.first?.locationInView(self) {
            let increase = point.y < self.bounds.size.height * 0.5
            value += increase ? 1 : -1
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    class ArrowsView: UIView {
        
        static private let plusString: NSString = "▲"
        static private let minusString: NSString = "▼"
        static private let attr: Dictionary<String, AnyObject> = [NSFontAttributeName : UIFont.boldSystemFontOfSize(14)]
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clearColor()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func intrinsicContentSize() -> CGSize {
            return CGSize(width: 20, height: UIViewNoIntrinsicMetric)
        }
        
        override func drawRect(rect: CGRect) {
            guard let font = ArrowsView.attr[NSFontAttributeName] as? UIFont else {
                return
            }
            let sz = font.pointSize
            let pfr = CGRectMake((rect.size.width - sz) * 0.5, (rect.size.height - sz) * 0.2, sz, sz)
            let mfr = CGRectMake((rect.size.width - sz) * 0.5, (rect.size.height - sz) * 0.8, sz, sz)
            ArrowsView.plusString.drawInRect(pfr, withAttributes: ArrowsView.attr)
            ArrowsView.minusString.drawInRect(mfr, withAttributes: ArrowsView.attr)
        }
        
    }
    
}
