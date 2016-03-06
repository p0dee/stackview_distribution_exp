//
//  ViewControllerPickerViewDataSource.swift
//  StackViewExample
//
//  Created by Takeshi Tanaka on 3/1/16.
//  Copyright © 2016 Takeshi Tanaka. All rights reserved.
//

import UIKit

extension ViewController {
    
    //MARK: <UIPickerViewDataSource>
    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    //MARK: <UIPickerViewDelegate>
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "Fill"
        case 1:
            return "FillEqually"
        case 2:
            return "FillProportionally"
        case 3:
            return "EqualSpacing"
        case 4:
            return "EqualCentering"
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stackView.distribution = UIStackViewDistribution(rawValue: row) ?? .Fill
        self.view.setNeedsDisplay()
    }
    
}
