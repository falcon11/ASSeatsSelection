//
//  ASCenterLineView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

enum ASCenterLineDirection {
    case Horizontal
    case Vertical
}

class ASCenterLineView: UIView {
    
    var direction: ASCenterLineDirection = .Vertical {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat {
        get {
            switch direction {
            case .Vertical:
                return self.width
            default:
                return self.height
            }
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
            setNeedsDisplay()
        }
    }
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
            setNeedsDisplay()
        }
    }
    
    var lineColor: UIColor = UIColor.orange {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = self.lineWidth
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor.cgColor)
        context?.setLineDash(phase: 0, lengths: [6, 2])
        context?.move(to: CGPoint.zero)
        switch direction {
        case .Vertical:
            context?.addLine(to: CGPoint(x: 0, y: bounds.height))
        default:
            context?.addLine(to: CGPoint(x: bounds.width, y: 0))
        }
        context?.strokePath()
    }

}
