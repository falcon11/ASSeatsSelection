//
//  ASSeatsSelectionView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ASSeatsSelectionView: UIView {
    
    lazy var hallLogoView: ASHallLogoView = {
        var hallLogoView = ASHallLogoView()
        return hallLogoView
    }()
    
    lazy var seatsScrollView: UIScrollView = {
        var seatsScrollView = UIScrollView()
        seatsScrollView.bounds = self.bounds
        self.addSubview(seatsScrollView)
        return seatsScrollView
    }()
    
    lazy var indicatorView: ASSeatsIndicatorView = {
        var indicatorView = ASSeatsIndicatorView()
        return indicatorView
    }()
    
    lazy var horizontalCenterLineview: ASCenterLineView = {
        var centerLineView = ASCenterLineView()
        return centerLineView
    }()
    
    lazy var seatsView: ASSeatsView = {
        var seatsView = ASSeatsView()
        return seatsView
    }()
    
    var seatsArray: Array<Array<ASSeatModel>>? {
        didSet {
            self.setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func setupViews() -> Void {
        self.seatsView.seatsArray = seatsArray
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
