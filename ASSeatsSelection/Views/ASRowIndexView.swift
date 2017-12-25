//
//  ASRowIndexView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 21/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

protocol ASRowIndexViewDataSource {
    func numberOfRowsIn(rowIndexView: ASRowIndexView) -> Int
    
    func rowIndexView(rowIndexView: ASRowIndexView, titleIn row: Int) -> String
}

class ASRowIndexView: UIView {
    
    var dataSource: ASRowIndexViewDataSource? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var rows: Int {
        get {
            var rows = dataSource?.numberOfRowsIn(rowIndexView: self) ?? 0
            rows = max(rows, 0)
            return rows
        }
    }
    
    var indexTextColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }
    
    var headerAndFooterHight: CGFloat = 10 {
        didSet {
            var frame = self.frame
            frame.size.height = contentHeight + 2 * headerAndFooterHight
            self.frame = frame
            self.setNeedsDisplay()
        }
    }
    
    var contentHeight: CGFloat = 100 {
        didSet {
            var frame = self.frame
            frame.size.height = contentHeight + 2 * headerAndFooterHight
            self.frame = frame
            self.setNeedsDisplay()
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        let rows = self.rows
        if rows <= 0 { return }
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10),
                             NSAttributedStringKey.foregroundColor: indexTextColor,
                             ] as [NSAttributedStringKey : Any]
        let rowHeight: CGFloat = contentHeight / CGFloat(rows)
        var y = headerAndFooterHight
        for i in 1...rows {
            let title = dataSource?.rowIndexView(rowIndexView: self, titleIn: (i - 1)) ?? " "
            let attributeString = NSAttributedString(string: title, attributes: attributes)
            let strSize = attributeString.size()
            attributeString.draw(at: CGPoint(x: (bounds.width - strSize.width)/2, y: y + (rowHeight - strSize.height)/2) )
            y = y + rowHeight
        }
    }

}
