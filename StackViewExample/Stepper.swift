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
        update(value: initialValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        titleLabel.textColor = self.tintColor
        valueLabel.textColor = self.tintColor
    }
    
    private func update(value: Int) {
        self.value = value
    }
    
    private func setupViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textAlignment = .right
        valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
        valueLabel.textAlignment = .right
    }
    
    private func setupLayout() {
        arrowsView.setContentHuggingPriority(251, for: .horizontal)
        let innerSv = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        innerSv.axis = .vertical
        let outerSv = UIStackView(arrangedSubviews: [innerSv, arrowsView])
        outerSv.translatesAutoresizingMaskIntoConstraints = false
        outerSv.spacing = 8
        outerSv.axis = .horizontal
        self.addSubview(outerSv)
        //constraints
        var cstrs = [NSLayoutConstraint]()
        cstrs += outerSv.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        cstrs += outerSv.topAnchor.constraint(equalTo: self.topAnchor)
        cstrs += outerSv.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        cstrs += outerSv.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate(cstrs)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let point = touches.first?.location(in: self) {
            let increase = point.y < self.bounds.size.height * 0.5
            value += increase ? 1 : -1
            sendActions(for: .valueChanged)
        }
    }
    
    class ArrowsView: UIView {
        
        static private let plusString: NSString = "▲"
        static private let minusString: NSString = "▼"
        static private let attr: Dictionary<String, AnyObject> = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clear
      }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 20, height: UIViewNoIntrinsicMetric)
        }
        
        override func draw(_ rect: CGRect) {
            guard let font = ArrowsView.attr[NSFontAttributeName] as? UIFont else {
                return
            }
            let sz = font.pointSize
            let pfr = CGRect(x: (rect.size.width - sz) * 0.5, y: (rect.size.height - sz) * 0.2, width: sz, height: sz)
            let mfr = CGRect(x: (rect.size.width - sz) * 0.5, y: (rect.size.height - sz) * 0.8, width: sz, height: sz)
            ArrowsView.plusString.draw(in: pfr, withAttributes: ArrowsView.attr)
            ArrowsView.minusString.draw(in: mfr, withAttributes: ArrowsView.attr)
        }
        
    }
    
}
