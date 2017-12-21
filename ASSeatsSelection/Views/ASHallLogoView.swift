//
//  ASHallLogoView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ASHallLogoView: UIView {
    
    var image: UIImage? {
        didSet {
            
            setNeedsDisplay()
        }
    }
    
    var hallName: String? = "银幕" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.backgroundColor = UIColor.clear
        addSubview(imageView)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        logoImageView.frame = bounds
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
//        guard let image = image else { return }
//        image.draw(at: CGPoint.zero)
        
        guard let hallName = hallName else {
            return
        }
//        let size = image.size
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10),
                          NSAttributedStringKey.foregroundColor: UIColor.black,
                          ]
        let attributeString = NSAttributedString(string: hallName, attributes: attributes)
        let strSize = attributeString.size()
        attributeString.draw(at: CGPoint(x: (bounds.width - strSize.width)/2, y: (bounds.height - strSize.height)/2))
    }

}
