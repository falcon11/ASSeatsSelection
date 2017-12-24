//
//  ASSeatsIndicatorView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ASSeatsIndicatorView: UIView {

    weak var mapView: UIView? {
        didSet {
            self.updateMapImageView()
        }
    }
    
    private var mapImageView: UIView? {
        get {
            return self.subviews.first
        }
        set {
            mapImageView?.removeFromSuperview()
            guard let view = newValue else {
                return
            }
            let radio = self.bounds.height / view.frame.height
            var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            frame.size.width = view.frame.width * radio
            frame.size.height = bounds.height
            view.frame = frame
            insertSubview(view, belowSubview: indicatorView)
        }
    }
    
    private var radio: CGFloat {
        get {
            guard let mapView = mapView else {
                return 1
            }
            return bounds.height / mapView.bounds.height
        }
    }
    
    lazy var indicatorView: UIView = {
        var indicatorView = UIView()
        indicatorView.backgroundColor = UIColor.clear
        indicatorView.layer.borderColor = UIColor.red.cgColor
        indicatorView.layer.borderWidth = 1.0
        self.addSubview(indicatorView)
        return indicatorView
    }()
    
    func updateMapImageView() -> Void {
        self.mapImageView = mapView?.snapshotView(afterScreenUpdates: true)
    }
    
    func updateIndicatorWithFrame(frame: CGRect) -> Void {
        var frame = frame
        frame.origin.x = frame.origin.x * radio
        frame.origin.y = frame.origin.y * radio
        frame.size.width = frame.width * radio
        frame.size.height = frame.height * radio
        indicatorView.frame = frame
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
