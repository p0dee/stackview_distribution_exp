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
        return self.blue
    }
    class func compressionResistanceColor() -> UIColor {
        return self.red
    }
}

// operators
func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func += <T> (lhs: inout Array<T>, rhs: T) {
    lhs.append(rhs)
}
