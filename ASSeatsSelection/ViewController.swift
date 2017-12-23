//
//  ViewController.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ASSeatsSelectionViewDataSource, ASSeatsSelectionViewDelegate {
    
    @IBOutlet weak var seatsView: ASSeatsSelectionView!
    var seats = [
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,],
        [],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,1,4,5],
//        [1,2,3,4,5,1,2],
//        [1,2,3,4,5,1,2],
//        [1,2,3,4,5,1,2],
//        [1,2,3,4,5,1,2],
//        [1,2,3,4,5,1,2],
//        [1,2,3,4,5,1,2],
//        [1,2,3,4,5,1,2],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        seatsView.hallName = "中瑞"
        seatsView.dataSource = self
        seatsView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ASSeatsSelectionViewDelegate
    
    func seatsSelectionView(_ seatsSelectionView: ASSeatsSelectionView, didSelectAt row: Int, column: Int) {
        if seats[row][column] % 4 == 2 {
            seats[row][column] = 0
        } else if seats[row][column] % 4 == 0 {
            seats[row][column] = 2
        }
    }
    
    // MARK: - ASSeatsSelectionViewDataSource
    
    func numberOfRowsIn(seatsSelectionView: ASSeatsSelectionView) -> Int {
        return seats.count
    }
    
    func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, numberOfColumnsIn row: Int) -> Int {
        return seats[row].count
    }
    
    func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, seatImageIn row: Int, column: Int, completion: (UIImage?) -> Void) {
        let number = seats[row][column]
        var image: UIImage? = nil
        switch number%4 {
        case 0:
            image = #imageLiteral(resourceName: "seat_selected.png")
        case 1:
            image = #imageLiteral(resourceName: "seat_sold.png")
        case 2:
            image = #imageLiteral(resourceName: "seat_available.png")
        default:
            break
        }
        completion(image)
    }
    
    func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, seatWidthIn row: Int, column: Int) -> CGFloat {
        if row % 4 == 3 && seats[row][column]%4 != 3 {
            return 10
        }
        return 10
    }
    
    func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, indexTitleIn row: Int) -> String {
        let seats = self.seats[row]
        return "\((seats.count>0 ? "\(row)" : ""))"
    }

}

