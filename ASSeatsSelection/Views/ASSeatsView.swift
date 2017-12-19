//
//  ASSeatsView.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ASSeatsView: UICollectionView {
    
    var seatsArray: Array<Array<ASSeatModel>>? {
        didSet {
            self.setupViews()
        }
    }
    
    var seatsButtons: Array<Array<ASSeatButton>> = []
    
    var defaultSoldImage = UIImage(named: "seat_sold")
    var defaultAvailableImage = UIImage(named: "seat_available")
    var defaultSelectedImage = UIImage(named: "seat_selected")
    
    func setupViews() -> Void {
        guard let seatsArray = seatsArray else {
            for seats in seatsButtons {
                for seat in seats { seat.removeFromSuperview() }
            }
            return
        }
        seatsButtons.removeAll()
        for seats in seatsArray {
            var rowButtons: Array<ASSeatButton> = []
            for seat in seats {
                var seatButton: ASSeatButton = ASSeatButton()
                self.addSubview(seatButton)
                var imageUrl = seat.imageUrl
                switch seat.type {
                case .edge:
                    seatButton.isEnabled = false
                case .sold:
                    seatButton.setImage(defaultSoldImage, for: .normal)
                    seatButton.isEnabled = false
                case .available:
                    seatButton.setImage(defaultAvailableImage, for: .normal)
                    seatButton.isEnabled = true
                case .selected:
                    seatButton.setImage(defaultSelectedImage, for: .normal)
                    seatButton.isEnabled = true
                }
                rowButtons.append(seatButton)
            }
            seatsButtons.append(rowButtons)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func seatButtonAction(button: UIButton) {
        
    }

}


