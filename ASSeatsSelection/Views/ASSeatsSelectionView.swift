//
//  ASSeatsSelectionView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

@objc protocol ASSeatsSelectionViewDelegate: NSObjectProtocol {
    @objc optional func seatsSelectionView(_ seatsSelectionView: ASSeatsSelectionView, didSelectAt row: Int, column: Int)
}

class ASSeatsSelectionView: UIView, UIScrollViewDelegate, ASSeatsDelegate {
    
    var soldImage = UIImage(named: "seat_sold")
    var availableImage = UIImage(named: "seat_available")
    var selectedImage = UIImage(named: "seat_selected")
    var zoomScale: CGFloat = 2.5 {
        didSet {
            self.seatsScrollView.setZoomScale(zoomScale, animated: true)
        }
    }
    
    lazy var hallLogoView: ASHallLogoView = {
        var hallLogoView = ASHallLogoView()
        return hallLogoView
    }()
    
    lazy var seatsScrollView: UIScrollView = {
        var seatsScrollView = UIScrollView()
        seatsScrollView.delegate = self
        seatsScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        seatsScrollView.contentInset = UIEdgeInsets.zero
        seatsScrollView.contentOffset = CGPoint.zero
        seatsScrollView.showsVerticalScrollIndicator = false
        seatsScrollView.showsHorizontalScrollIndicator = false
        seatsScrollView.minimumZoomScale = 1.0
        seatsScrollView.maximumZoomScale = 3
        seatsScrollView.frame = self.bounds
        seatsScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight,]
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
        self.seatsScrollView.addSubview(seatsView)
        return seatsView
    }()
    
    var dataSource: ASSeatsDataSource? {
        didSet {
            seatsView.dataSource = dataSource
            seatsView.frame = CGRect(x: 0, y: 0, width: seatsView.width, height: seatsView.height)
//            seatsScrollView.contentInset = UIEdgeInsetsMake(60, (seatsScrollView.bounds.width-seatsView.width)/2, 60, (seatsScrollView.bounds.width-seatsView.width)/2)
            let rect = self.zoomRectFor(scrollView: self.seatsScrollView, scale: 2.5, center: seatsView.center)
            seatsScrollView.zoom(to: rect, animated: true)
        }
    }
    var delegate: ASSeatsSelectionViewDelegate? {
        didSet {
            seatsView.delegate = self
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() -> Void {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return seatsView
    }
    
    func zoomRectFor(scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect()
        let scale = scale > 0 ? scale : 1
        zoomRect.size.width = scrollView.bounds.width / scale
        zoomRect.size.height = scrollView.bounds.height / scale
        zoomRect.origin.x = center.x - zoomRect.size.width / 2
        zoomRect.origin.y = center.y - zoomRect.size.height / 2
        return zoomRect
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        seatsView.center = contentCenter(forBoundingSize: seatsScrollView.bounds.size, contentSize: seatsScrollView.contentSize)
    }
    
    func contentCenter(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGPoint {
        
        /// When the zoom scale changes i.e. the image is zoomed in or out, the hypothetical center
        /// of content view changes too. But the default Apple implementation is keeping the last center
        /// value which doesn't make much sense. If the image ratio is not matching the screen
        /// ratio, there will be some empty space horizontally or vertically. This needs to be calculated
        /// so that we can get the correct new center value. When these are added, edges of contentView
        /// are aligned in realtime and always aligned with corners of scrollView.
        
        let horizontalOffset = (boundingSize.width > contentSize.width) ? ((boundingSize.width - contentSize.width) * 0.5): 0.0
        let verticalOffset   = (boundingSize.height > contentSize.height) ? ((boundingSize.height - contentSize.height) * 0.5): 0.0
        
        return CGPoint(x: contentSize.width * 0.5 + horizontalOffset, y: contentSize.height * 0.5 + verticalOffset)
    }
    
    // MARK: - ASSeatsDelegate
    
    func didSelectedSeatAt(row: Int, column: Int) {
        self.delegate?.seatsSelectionView?(self, didSelectAt: row, column: column)
        guard let seat = self.seatsView.seatFor(row: row, column: column) else { return }
        // seat button center in the seatsView, not the seatsScrollView
        let point = seat.center//self.seatsScrollView.convert(seat.center, from: self.seatsView)
        if abs(self.seatsScrollView.maximumZoomScale - self.seatsScrollView.zoomScale) < 0.1 { return }
        let rect = self.zoomRectFor(scrollView: self.seatsScrollView, scale: self.seatsScrollView.maximumZoomScale, center: point)
        self.seatsScrollView.zoom(to: rect, animated: true)
        self.seatsView.layoutIfNeeded()
    }

}
