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

@objc protocol ASSeatsSelectionViewDataSource: NSObjectProtocol {
    
    func numberOfRowsIn(seatsSelectionView: ASSeatsSelectionView) -> Int
    
    @objc optional func  seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, numberOfColumnsIn row: Int) -> Int
    
    func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, seatImageIn row:Int, column:Int, completion:(_ image: UIImage?)->Void)
    
    @objc optional func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, seatWidthIn row:Int, column: Int) -> CGFloat
    
    @objc optional func heightForRowIn(seatsSelectionView: ASSeatsSelectionView) -> CGFloat
    
    @objc optional func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, indexTitleIn row: Int) -> String

}

class ASSeatsSelectionView: UIView, UIScrollViewDelegate, ASSeatsDelegate {
    
    var hallLogoImage = UIImage(named: "hall_logo_view") {
        didSet {
            hallLogoView.image = hallLogoImage
        }
    }
    var hallName = "银幕" {
        didSet {
            hallLogoView.hallName = hallName
        }
    }
    var zoomScale: CGFloat = 2.5 {
        didSet {
            self.seatsScrollView.setZoomScale(zoomScale, animated: true)
        }
    }
    
    var indicatorViewHeight: CGFloat = 64 {
        didSet {
            var frame = indicatorView.frame
            frame.size.height = indicatorViewHeight
            indicatorView.frame = frame
        }
    }
    
    private lazy var hallLogoView: ASHallLogoView = {
        var hallLogoView = ASHallLogoView(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        hallLogoView.hallName = "银幕"
        hallLogoView.image = hallLogoImage
        seatsScrollView.addSubview(hallLogoView)
        return hallLogoView
    }()
    
    private lazy var seatsScrollView: UIScrollView = {
        var seatsScrollView = UIScrollView()
        seatsScrollView.delegate = self
        seatsScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        seatsScrollView.showsVerticalScrollIndicator = false
        seatsScrollView.showsHorizontalScrollIndicator = false
        seatsScrollView.minimumZoomScale = 1.0
        seatsScrollView.maximumZoomScale = 3
        seatsScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        seatsScrollView.frame = self.bounds
        self.addSubview(seatsScrollView)
        return seatsScrollView
    }()
    
    private lazy var indicatorView: ASSeatsIndicatorView = {
        var indicatorView = ASSeatsIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: indicatorViewHeight))
        indicatorView.mapView = self.seatsView
        self.addSubview(indicatorView)
        return indicatorView
    }()
    
    private lazy var horizontalCenterLineview: ASCenterLineView = {
        var centerLineView = ASCenterLineView()
        centerLineView.direction = .Horizontal
        centerLineView.height = 1
        seatsScrollView.insertSubview(centerLineView, belowSubview: seatsView)
        return centerLineView
    }()
    
    private lazy var verticalCenterLineView: ASCenterLineView = {
        var centerLineView = ASCenterLineView()
        centerLineView.direction = .Vertical
        centerLineView.width = 1
        seatsScrollView.insertSubview(centerLineView, belowSubview: seatsView)
        return centerLineView
    }()
    
    private lazy var seatsView: ASSeatsView = {
        var seatsView = ASSeatsView()
        self.seatsScrollView.insertSubview(seatsView, at: 0)
        return seatsView
    }()
    
    private lazy var rowIndexView: ASRowIndexView = {
        var rowIndexView = ASRowIndexView(frame: CGRect(x: 0, y: -10, width: 13, height: bounds.height))
        rowIndexView.headerAndFooterHight = 10
        seatsScrollView.addSubview(rowIndexView)
        return rowIndexView
    }()
    
    var dataSource: ASSeatsSelectionViewDataSource? {
        didSet {
            seatsView.dataSource = self
            rowIndexView.dataSource = self
            seatsView.frame = CGRect(x: 0, y: 0, width: seatsView.width, height: seatsView.height)
            let horizontalInset = (seatsScrollView.bounds.width-seatsView.width) / 2
            seatsScrollView.contentInset = UIEdgeInsetsMake(indicatorViewHeight, horizontalInset, 60, horizontalInset)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadSeatsSelectionView() {
        self.seatsScrollView.zoomScale = 1
        self.seatsView.reloadSeatsView()
        self.seatsView.frame = CGRect(x: 0, y: 0, width: self.seatsView.width, height: self.seatsView.height)
        //should set seatsScrollView.contentSize to seatsView.bounds.size
        self.seatsScrollView.contentSize = self.seatsView.bounds.size
        let rect = self.zoomRectFor(scrollView: self.seatsScrollView, scale: 2.5, center: seatsView.center)
        seatsScrollView.zoom(to: rect, animated: true)
    }
    
    func reloadSeatAt(row: Int, column: Int) {
        seatsView.reloadSeatAt(row: row, column: column)
    }
    
    func updateView() {
        updateHallLogoView()
        updateRowIndexView()
        updateCenterLine()
        updateIndicatorView()
    }
    
    func updateHallLogoView() -> Void {
        let hallLogoView = self.hallLogoView
        var frame = hallLogoView.frame
        frame.origin.y = seatsScrollView.contentOffset.y
        hallLogoView.frame = frame
        var center = hallLogoView.center
        center.x = seatsView.center.x
        hallLogoView.center = center
    }
    
    func updateRowIndexView() -> Void {
        rowIndexView.contentHeight = seatsView.frame.height
        var frame = rowIndexView.frame
        frame.origin.x = seatsScrollView.contentOffset.x + 10
        rowIndexView.frame = frame
        var center = rowIndexView.center
        center.y = seatsView.center.y
        rowIndexView.center = center
    }
    
    func updateCenterLine() {
        verticalCenterLineView.height = seatsView.frame.height + 10
        verticalCenterLineView.center = seatsView.center
        horizontalCenterLineview.width = seatsView.frame.width + 10
        horizontalCenterLineview.center = seatsView.center
    }
    
    func updateIndicatorView() {
        indicatorView.alpha = 1
        indicatorView.isHidden = false
        var frame = CGRect()
        let scale = seatsScrollView.zoomScale
        frame.origin.x = max(seatsScrollView.contentOffset.x / scale, 0)
        frame.origin.y = max(seatsScrollView.contentOffset.y / scale, 0)
        frame.size.width = seatsScrollView.frame.width / scale
        if seatsScrollView.contentOffset.x < 0 {
            frame.size.width = frame.size.width + seatsScrollView.contentOffset.x / scale
        }
        if (frame.origin.x + frame.size.width) > seatsScrollView.contentSize.width / scale {
            frame.size.width = seatsScrollView.contentSize.width / scale - frame.origin.x
        }
        frame.size.height = seatsScrollView.frame.height / scale
        if seatsScrollView.contentOffset.y < 0 {
            frame.size.height = frame.size.height + seatsScrollView.contentOffset.y / scale
        }
        if (frame.origin.y + frame.size.height) > seatsScrollView.contentSize.height / scale {
            frame.size.height = seatsScrollView.contentSize.height / scale - frame.origin.y
        }
        indicatorView.updateIndicatorWithFrame(frame: frame)
    }
    
    @objc func hiddenIndicator() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            self.indicatorView.alpha = 0.5
        }) { [unowned self] (finished) in
            self.indicatorView.isHidden = true
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateView()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        type(of: self).cancelPreviousPerformRequests(withTarget: self, selector: #selector(hiddenIndicator), object: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.perform(#selector(hiddenIndicator), with: nil, afterDelay: 2)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    
    ///
    ///
    /// - Parameters:
    ///   - scrollView:
    ///   - scale:
    ///   - center: a CGPoint (relative to the view to zoom)
    /// - Returns:
    func zoomRectFor(scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect {
        var scale = CGFloat.minimum(scale, scrollView.maximumZoomScale)
        scale = CGFloat.maximum(scale, scrollView.minimumZoomScale)
        // not perform well as expected
        //Normalize current content size back to content scale of 1.0f
//        let contentSize = CGSize(width: (scrollView.contentSize.width / scrollView.zoomScale), height: (scrollView.contentSize.height / scrollView.zoomScale))
//
//        //translate the zoom point to relative to the content rect
//        let translatedZoomPoint = CGPoint(x: (center.x / scrollView.bounds.size.width) * contentSize.width, y: (center.y / scrollView.bounds.size.height) * contentSize.height)
        
        // not perform well as expected
//        var translatedZoomPoint : CGPoint = .zero
//        translatedZoomPoint.x = center.x + scrollView.contentOffset.x
//        translatedZoomPoint.y = center.y + scrollView.contentOffset.y
//
//        let zoomFactor = 1.0 / scrollView.zoomScale
//
//        translatedZoomPoint.x *= zoomFactor
//        translatedZoomPoint.y *= zoomFactor
        let translatedZoomPoint = center
        var zoomRect: CGRect = CGRect()
        zoomRect.size.width = scrollView.bounds.width / scale
        zoomRect.size.height = scrollView.bounds.height / scale
        zoomRect.origin.x = translatedZoomPoint.x - zoomRect.size.width / 2
        zoomRect.origin.y = translatedZoomPoint.y - zoomRect.size.height / 2
        return zoomRect
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // don't need to center the content now
//        seatsView.center = contentCenter(forBoundingSize: seatsScrollView.bounds.size, contentSize: seatsScrollView.contentSize)
        type(of: self).cancelPreviousPerformRequests(withTarget: self, selector: #selector(hiddenIndicator), object: nil)
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
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        updateView()
        scrollViewDidEndDecelerating(scrollView)
    }
    
    
    // MARK: - ASSeatsDelegate
    
    func didSelectedSeatAt(row: Int, column: Int) {
        self.delegate?.seatsSelectionView?(self, didSelectAt: row, column: column)
        guard let seat = self.seatsView.seatFor(row: row, column: column) else { return }
        let point = seat.center//self.seatsScrollView.convert(seat.center, from: self.seatsView)
        if abs(self.seatsScrollView.maximumZoomScale - self.seatsScrollView.zoomScale) < 0.1 { return }
        let rect = self.zoomRectFor(scrollView: self.seatsScrollView, scale: self.seatsScrollView.maximumZoomScale, center: point)
        self.seatsScrollView.zoom(to: rect, animated: true)
        self.seatsView.layoutIfNeeded()
    }
    
    func didUpdated(seatsView: ASSeatsView) {
        indicatorView.updateMapImageView()
    }

}

extension ASSeatsSelectionView: ASSeatsDataSource, ASRowIndexViewDataSource {
    
    // MARK: - ASSeatsDataSource
    func numberOfRows() -> Int {
        return dataSource?.numberOfRowsIn(seatsSelectionView: self) ?? 0
    }
    
    func numberOfSeatsFor(row: Int) -> Int {
        return dataSource?.seatsSelectionView?(seatsSelectionView: self, numberOfColumnsIn: row) ?? 0
    }
    
    func seatImageFor(_ row: Int, column: Int, completion: (UIImage?) -> Void) {
        dataSource?.seatsSelectionView(seatsSelectionView: self, seatImageIn: row, column: column, completion: { (image) in
            completion(image)
        })
    }
    
    func widthFor(_ row: Int, column: Int) -> CGFloat {
        return dataSource?.seatsSelectionView?(seatsSelectionView: self, seatWidthIn: row, column: column) ?? 10
    }
    
    func heightForSeat() -> CGFloat {
        return dataSource?.heightForRowIn?(seatsSelectionView: self) ?? 10
    }
    
    // MARK: - ASRowIndexViewDataSource
    
    func numberOfRowsIn(rowIndexView: ASRowIndexView) -> Int {
        return dataSource?.numberOfRowsIn(seatsSelectionView: self) ?? 0
    }
    
    func rowIndexView(rowIndexView: ASRowIndexView, titleIn row: Int) -> String {
        return dataSource?.seatsSelectionView?(seatsSelectionView: self, indexTitleIn: row) ?? " "
    }
    
}
