//
//  ViewController.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ASSeatsDataSource, ASSeatsSelectionViewDelegate {
    
    @IBOutlet weak var seatsView: ASSeatsSelectionView!
    var seats = [
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        seatsView.dataSource = self
        seatsView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfRows() -> Int {
        return seats.count
    }
    
    func numberOfSeatsFor(row: Int) -> Int {
        return seats[row].count
    }
    
    func seatImageFor(_ row: Int, column: Int, completion: (UIImage?) -> Void) {
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
    
    func widthFor(_ row: Int, column: Int) -> CGFloat {
        if row % 4 == 3 && seats[row][column]%4 != 3 {
            return 25
        }
        return 10
    }
    
    func seatsSelectionView(_ seatsSelectionView: ASSeatsSelectionView, didSelectAt row: Int, column: Int) {
        if seats[row][column] % 4 == 2 {
            seats[row][column] = 0
        } else if seats[row][column] % 4 == 0 {
            seats[row][column] = 2
        }
    }
    
    

}

