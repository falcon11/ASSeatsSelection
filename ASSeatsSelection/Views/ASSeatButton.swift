//
//  ASSeatButton.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ASSeatButton: UIButton {

    var scale: CGFloat = 0.95
    var row: Int?
    var column: Int?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width : CGFloat = bounds.width * scale
        let height: CGFloat = bounds.height * scale
        let x: CGFloat = (bounds.width - width) * 0.5
        let y: CGFloat = (bounds.height - height) * 0.5
        imageView?.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
