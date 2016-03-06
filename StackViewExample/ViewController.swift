//
//  ViewController.swift
//  StackViewExample
//
//  Created by Takeshi Tanaka on 2/27/16.
//  Copyright © 2016 Takeshi Tanaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let huggingStepper: Stepper
    let compressionResistanceStepper: Stepper
    let stackView: UIStackView
    let pickerView: UIPickerView
    
    var selectedLabel: ColouredLabel? {
        didSet {
            if let selectedLabel = selectedLabel {
                huggingStepper.value = Int(selectedLabel.contentHuggingPriorityForAxis(stackView.axis))
                compressionResistanceStepper.value = Int(selectedLabel.contentCompressionResistancePriorityForAxis(stackView.axis))
            }
        }
    }
    
    var labels = [ColouredLabel]()

    required init?(coder aDecoder: NSCoder) {
        huggingStepper = Stepper(title: "Hugging")
        compressionResistanceStepper = Stepper(title: "Compression Resistance")
        stackView = UIStackView()
        pickerView = UIPickerView()
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = StackViewDetectorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        let handler: ColouredLabel.DidSelectHandler = {
            self.selectedLabel = $0
            self.labels.filter { !$0.isEqual(self.selectedLabel) }.forEach { $0.selected = false }
        }
//        labels.append(ColouredLabel(text: "line 1\nline 2\nline 3", backgroundColor: UIColor.yellowColor())) //multi lines example
        labels.append(ColouredLabel(text: "p0dee", backgroundColor: UIColor.yellowColor()))
        labels.append(ColouredLabel(text: "Takeshi", backgroundColor: UIColor.cyanColor()))
        labels.append(ColouredLabel(text: "tale", backgroundColor: UIColor.magentaColor()))
        labels.forEach {
            stackView.addArrangedSubview($0)
            $0.handler = handler
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Horizontal
//        stackView.alignment = .Center
        self.view.addSubview(stackView)
        
        huggingStepper.translatesAutoresizingMaskIntoConstraints = false
        huggingStepper.tintColor = UIColor.huggingColor()
        huggingStepper.addTarget(self, action: "didChangeHuggingPriorityValue:", forControlEvents: .ValueChanged)
        self.view.addSubview(huggingStepper)
        compressionResistanceStepper.translatesAutoresizingMaskIntoConstraints = false
        compressionResistanceStepper.tintColor = UIColor.compressionResistanceColor()
        compressionResistanceStepper.addTarget(self, action: "didChangeCompressionResistancePriorityValue:", forControlEvents: .ValueChanged)
        self.view.addSubview(compressionResistanceStepper)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        self.view.addSubview(pickerView)
        
        setupConstraints()
    }

    //MARK:
    private func setupConstraints() {
        var cstrs = [NSLayoutConstraint]()
        cstrs += stackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        cstrs += stackView.topAnchor.constraintEqualToAnchor(huggingStepper.bottomAnchor, constant: 10)
        cstrs += stackView.widthAnchor.constraintEqualToConstant(300)
        cstrs += stackView.heightAnchor.constraintEqualToConstant(100)
        cstrs += huggingStepper.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.topAnchor, constant: 30) //???
        cstrs += compressionResistanceStepper.topAnchor.constraintEqualToAnchor(huggingStepper.topAnchor)
        cstrs += huggingStepper.leadingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.leadingAnchor)
        cstrs += compressionResistanceStepper.trailingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.trailingAnchor)
        cstrs += huggingStepper.widthAnchor.constraintEqualToAnchor(compressionResistanceStepper.widthAnchor)
        cstrs += pickerView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        cstrs += pickerView.topAnchor.constraintEqualToAnchor(stackView.bottomAnchor)
        NSLayoutConstraint.activateConstraints(cstrs)
    }
    
    @objc func didChangeCompressionResistancePriorityValue(sender: Stepper) {
        guard let selectedLabel = selectedLabel else {
            return
        }
        selectedLabel.setContentCompressionResistancePriority(Float(sender.value), forAxis: stackView.axis)
        self.view.setNeedsDisplay()
    }
    
    @objc func didChangeHuggingPriorityValue(sender: Stepper) {
        guard let selectedLabel = selectedLabel else {
            return
        }
        selectedLabel.setContentHuggingPriority(Float(sender.value), forAxis: stackView.axis)
        self.view.setNeedsDisplay()
    }
}


class StackViewDetectorView: UIView {
    
    private let cmpAttr = [NSFontAttributeName : UIFont.boldSystemFontOfSize(11), NSForegroundColorAttributeName : UIColor.compressionResistanceColor()]
    private let hggAttr = [NSFontAttributeName : UIFont.boldSystemFontOfSize(11), NSForegroundColorAttributeName : UIColor.huggingColor()]
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIColor.whiteColor().setFill()
        let stackViews = self.subviews.filter { $0 is UIStackView } as! [UIStackView]
        stackViews.forEach { view in
            CGContextFillRect(context, view.frame)
            view.arrangedSubviews.forEach {
                let rect = $0.frame
                var point = rect.origin + view.frame.origin
                point.x += view.axis == .Vertical ? rect.size.width : 0
                point.y += view.axis == .Horizontal ? rect.size.height : 0
                contentPriorityDescriotionText($0, view.axis).drawAtPoint(point)
            }
        }
    }
    
    private func contentPriorityDescriotionText(view: UIView, _ axis: UILayoutConstraintAxis) -> NSAttributedString {
        let str = NSMutableAttributedString()
        str.appendAttributedString(NSAttributedString(string: "\(Int(view.contentHuggingPriorityForAxis(axis)))", attributes: hggAttr))
        str.appendAttributedString(NSAttributedString(string: "\n", attributes: nil))
        str.appendAttributedString(NSAttributedString(string: "\(Int(view.contentCompressionResistancePriorityForAxis(axis)))", attributes: cmpAttr))
        return str
    }
    
}
