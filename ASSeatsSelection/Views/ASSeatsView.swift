//
//  ASSeatsView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit


/// data source like UITableViewDataSource
@objc protocol ASSeatsDataSource: NSObjectProtocol {
    func numberOfRows() -> Int
    @objc optional func numberOfSeatsFor(row: Int) -> Int
    
    /// you can set image for the seat
    ///
    /// - Parameters:
    ///   - row: row
    ///   - column:
    ///   - completion:
    @objc optional func seatImageFor(_ row: Int, column: Int, completion: (_ image: UIImage?)->Void)
    @objc optional func widthFor(_ row: Int, column: Int) -> CGFloat
    @objc optional func heightForSeat() -> CGFloat
}

@objc protocol ASSeatsDelegate: NSObjectProtocol {
    func didSelectedSeatAt(row: Int, column: Int)
    @objc optional func didUpdated(seatsView: ASSeatsView)
}

class ASSeatsView: UIView {
    
    var seatsButtons: Array<ASSeatButton> = []
    var defaultSeatWidth: CGFloat = 10.0
    var defaultSeatHeight: CGFloat = 10.0
    var dataSource: ASSeatsDataSource? {
        didSet{
            self.reloadSeatsView()
        }
    }
    var delegate: ASSeatsDelegate?
    var rows: Int {
        get {
            return dataSource?.numberOfRows() ?? 0
        }
    }
    
    var seatHeight: CGFloat {
        get {
            let seatHeight: CGFloat = dataSource?.heightForSeat?() ?? defaultSeatHeight
            return seatHeight
        }
    }
    var height: CGFloat {
        get {
            return seatHeight * CGFloat(rows)
        }
    }
    
    private(set) var width: CGFloat = 0
    
    func reloadSeatsView() {
        for seat in seatsButtons {
            seat.removeFromSuperview()
        }
        seatsButtons.removeAll()
        guard let dataSource = dataSource else { return }
        let rows: Int = self.rows
        if rows == 0 { return }
        let seatHeight: CGFloat = self.seatHeight
        for row in 0...(rows-1) {
            var x: CGFloat = 0.0
            let y: CGFloat = seatHeight * CGFloat(row)
            let colums: Int = dataSource.numberOfSeatsFor?(row: row) ?? 0
            if colums <= 0 { continue }
            for column in 0...(colums-1) {
                let seat = ASSeatButton()
                dataSource.seatImageFor?(row, column: column, completion: { (image) in
                    seat.setImage(image, for: .normal)
                })
                seat.addTarget(self, action: #selector(seatButtonAction(button:)), for: .touchUpInside)
                seat.row = row
                seat.column = column
                let width: CGFloat = dataSource.widthFor?(row, column: column) ?? defaultSeatWidth
                seat.frame = CGRect(x: x, y: y, width: width, height: seatHeight)
                self.addSubview(seat)
                seatsButtons.append(seat)
                x = x + width
            }
            width = width < x ? x : width
        }
        delegate?.didUpdated?(seatsView: self)
    }
    
    func reload(seatButton: ASSeatButton) {
        dataSource?.seatImageFor?(seatButton.row!, column: seatButton.column!, completion: { (image) in
            DispatchQueue.main.async {
                seatButton.setImage(image, for: .normal)
                self.delegate?.didUpdated?(seatsView: self)
            }
        })
    }
    
    @objc func seatButtonAction(button: ASSeatButton) {
        self.delegate?.didSelectedSeatAt(row: button.row!, column: button.column!)
        self.reload(seatButton: button)
    }
    
    func seatFor(row: Int, column: Int) -> ASSeatButton? {
        for seat in seatsButtons {
            if seat.row == row && seat.column == column {
                return seat
            }
        }
        return nil
    }

}


