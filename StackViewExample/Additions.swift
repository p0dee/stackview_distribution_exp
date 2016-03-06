//
//  Additions.swift
//  StackViewExample
//
//  Created by Takeshi Tanaka on 2/28/16.
//  Copyright © 2016 Takeshi Tanaka. All rights reserved.
//

import UIKit

extension UIColor {
    class func huggingColor() -> UIColor {
        return self.blueColor()
    }
    class func compressionResistanceColor() -> UIColor {
        return self.redColor()
    }
}

// operators
func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func += <T> (inout lhs: Array<T>, rhs: T) {
    lhs.append(rhs)
}
