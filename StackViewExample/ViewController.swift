//
//  ViewController.swift
//  StackViewExample
//
//  Created by Takeshi Tanaka on 2/27/16.
//  Copyright © 2016 Takeshi Tanaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let huggingStepper: Stepper
    let compressionResistanceStepper: Stepper
    let stackView: UIStackView
    let pickerView: UIPickerView
    
    var selectedLabel: ColouredLabel? {
        didSet {
            if let selectedLabel = selectedLabel {
                huggingStepper.value = Int(selectedLabel.contentHuggingPriority(for: stackView.axis))
                compressionResistanceStepper.value = Int(selectedLabel.contentCompressionResistancePriority(for: stackView.axis))
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
        self.view.backgroundColor = UIColor.lightGray
        let handler: ColouredLabel.DidSelectHandler = {
            self.selectedLabel = $0
            self.labels.filter { !$0.isEqual(self.selectedLabel) }.forEach { $0.selected = false }
        }
//        labels.append(ColouredLabel(text: "line 1\nline 2\nline 3", backgroundColor: UIColor.yellowColor())) //multi lines example
        labels.append(ColouredLabel(text: "p0dee", backgroundColor: UIColor.yellow))
        labels.append(ColouredLabel(text: "Takeshi", backgroundColor: UIColor.cyan))
        labels.append(ColouredLabel(text: "tale", backgroundColor: UIColor.magenta))
        labels.forEach {
            stackView.addArrangedSubview($0)
            $0.handler = handler
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
//        stackView.alignment = .Center
        self.view.addSubview(stackView)
        
        huggingStepper.translatesAutoresizingMaskIntoConstraints = false
        huggingStepper.tintColor = UIColor.huggingColor()
        huggingStepper.addTarget(self, action: Selector(("didChangeHuggingPriorityValue:")), for: .valueChanged)
        self.view.addSubview(huggingStepper)
        compressionResistanceStepper.translatesAutoresizingMaskIntoConstraints = false
        compressionResistanceStepper.tintColor = UIColor.compressionResistanceColor()
        compressionResistanceStepper.addTarget(self, action: Selector(("didChangeCompressionResistancePriorityValue:")), for: .valueChanged)
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
        cstrs += stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        cstrs += stackView.topAnchor.constraint(equalTo: huggingStepper.bottomAnchor, constant: 10)
        cstrs += stackView.widthAnchor.constraint(equalToConstant: 300)
        cstrs += stackView.heightAnchor.constraint(equalToConstant: 100)
        cstrs += huggingStepper.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor, constant: 30) //???
        cstrs += compressionResistanceStepper.topAnchor.constraint(equalTo: huggingStepper.topAnchor)
        cstrs += huggingStepper.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor)
        cstrs += compressionResistanceStepper.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        cstrs += huggingStepper.widthAnchor.constraint(equalTo: compressionResistanceStepper.widthAnchor)
        cstrs += pickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        cstrs += pickerView.topAnchor.constraint(equalTo: stackView.bottomAnchor)
        NSLayoutConstraint.activate(cstrs)
    }
    
    @objc func didChangeCompressionResistancePriorityValue(sender: Stepper) {
        guard let selectedLabel = selectedLabel else {
            return
        }
        selectedLabel.setContentCompressionResistancePriority(Float(sender.value), for: stackView.axis)
        self.view.setNeedsDisplay()
    }
    
    @objc func didChangeHuggingPriorityValue(sender: Stepper) {
        guard let selectedLabel = selectedLabel else {
            return
        }
        selectedLabel.setContentHuggingPriority(Float(sender.value), for: stackView.axis)
        self.view.setNeedsDisplay()
    }
}


class StackViewDetectorView: UIView {
    
    private let cmpAttr = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 11), NSForegroundColorAttributeName : UIColor.compressionResistanceColor()]
    private let hggAttr = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 11), NSForegroundColorAttributeName : UIColor.huggingColor()]
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIColor.white.setFill()
        let stackViews = self.subviews.filter { $0 is UIStackView } as! [UIStackView]
        stackViews.forEach { view in
            context?.fill(view.frame)
            view.arrangedSubviews.forEach {
                let rect = $0.frame
                var point = rect.origin + view.frame.origin
                point.x += view.axis == .vertical ? rect.size.width : 0
                point.y += view.axis == .horizontal ? rect.size.height : 0
                contentPriorityDescriotionText(view: $0, view.axis).draw(at: point)
                
            }
        }
    }
    
    private func contentPriorityDescriotionText(view: UIView, _ axis: UILayoutConstraintAxis) -> NSAttributedString {
        let str = NSMutableAttributedString()
        str.append(NSAttributedString(string: "\(Int(view.contentHuggingPriority(for: axis)))", attributes: hggAttr))
        str.append(NSAttributedString(string: "\n", attributes: nil))
        str.append(NSAttributedString(string: "\(Int(view.contentCompressionResistancePriority(for: axis)))", attributes: cmpAttr))
        return str
    }
    
}
