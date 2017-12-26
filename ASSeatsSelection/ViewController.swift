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
    let a = [
        [1,2,3,4,5,1,2],
        [1,2,3,4,5,1,2],
        [1,2,3,4,5,1,2],
        [1,2,3,4,5,1,2],
        [1,2,3,4,5,1,2],
        [1,2,3,4,5,1,2],
        [1,2,3,4,5,1,2],
        ]
    let b = [
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,],
        [], //if this row have no seats or is corridor, you can just use an empty array
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,],
        [1,2,3,4,5,1,2,3,1,2,3,1,2,3,1,4,5],
        ]
    
    var seats: Array<Array<Int>>!
    var selectedSeats: Array<IndexPath> = [] {
        didSet {
            print("selected seats change")
            updateSelectedStackView()
        }
    }
    var maxSelected: Int = 4
    @IBOutlet weak var selectedSeatsStackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seats = b
        // Do any additional setup after loading the view, typically from a nib.
        setupSeatsViewWithConfiguration()
    }
    
    func setupSeatsView() -> Void {
        seatsView.hallName = "大银幕"
        seatsView.hallLogoSize = CGSize(width: 200, height: 20)
        seatsView.hallNameColor = UIColor.green
        seatsView.indicatorColor = UIColor.orange
        seatsView.indicatorViewHeight = 64
        seatsView.rowIndexViewTextColor = UIColor.orange
        seatsView.rowIndexViewBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        seatsView.dataSource = self
        seatsView.delegate = self
    }
    
    func setupSeatsViewWithConfiguration() {
        let configuration: ASSeatsSelectionConfigure = [
            .hallLogoConfiguration(.hallName("7-11")),
            .hallLogoConfiguration(.hallLogoSize(CGSize(width: 200, height: 20))),
            .hallLogoConfiguration(.hallNameColor(UIColor.green)),
            .indicatorConfiguration(.indicatorBorderColor(UIColor.green)),
            .indicatorConfiguration(.indicatorViewHeight(64)),
            .indicatorConfiguration(.indicatorBorderColor(UIColor.orange)),
            .rowIndexConfiguration(.backgroundColor(UIColor.cyan.withAlphaComponent(0.5))),
            .rowIndexConfiguration(.titleColor(UIColor.purple)),
            .centerLineConfiguration(.lineColor(UIColor.red)),
            .centerLineConfiguration(.lineWidth(1)),
            .centerLineConfiguration(.isHiddenLine(.Horizontal, true)),
        ]
        seatsView.setupWithConfiguration(configuration: configuration)
        seatsView.dataSource = self
        seatsView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSelectedStackView() -> Void {
        let subViews = selectedSeatsStackView.subviews
        for view in subViews {
            let index = view.tag
            if type(of: view) == UIButton.self && (index < selectedSeats.count)  {
                let button = view as! UIButton
                let indexPath = selectedSeats[index]
                button.setTitle("(\(indexPath.row), \(indexPath.section)) x", for: .normal)
            } else if type(of: view) == UIButton.self {
                let button = view as! UIButton
                button.setTitle("\((index + 1))", for: .normal)
            }
        }
        selectedSeatsStackView.sizeToFit()
        selectedSeatsStackView.layoutIfNeeded()
    }
    
    @IBAction func changeAction(_ sender: UIButton) {
        seats = arc4random() % 2 == 1 ? a : b
        selectedSeats.removeAll()
        seatsView.reloadSeatsSelectionView()
    }
    
    @IBAction func selectedSeatsButtonAction(_ sender: UIButton) {
        if (sender.tag + 1) > selectedSeats.count { return }
        let indexPath = selectedSeats[sender.tag]
        seats[indexPath.row][indexPath.section] = 2
        seatsView.reloadSeatAt(row: indexPath.row, column: indexPath.section)
        selectedSeats.remove(at: sender.tag)
    }
    
    // MARK: - ASSeatsSelectionViewDelegate
    
    func seatsSelectionView(_ seatsSelectionView: ASSeatsSelectionView, didSelectAt row: Int, column: Int) {
        let indexPath = IndexPath(row: row, section: column)
        // %4 == 2 available
        if seats[row][column] % 4 == 2 {
            // set to selected
            seats[row][column] = 0
            selectedSeats.append(indexPath)
        } else if seats[row][column] % 4 == 0 {
            // %4 == 0 selected, set to available
            seats[row][column] = 2
            if let index = selectedSeats.index(of: indexPath) {
                selectedSeats.remove(at: index)
            }
        }
        print("selected seats: \(selectedSeats)")
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
            image = UIImage(named: "seat_selected")
        case 1:
            image = UIImage(named: "seat_sold")
        case 2:
            image = UIImage(named: "seat_available")
        default:
            break
        }
        completion(image)
    }
    
    func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, seatWidthIn row: Int, column: Int) -> CGFloat {
        if row % 4 == 3 && seats[row][column]%4 != 3 {
            return 20
        }
        return 10
    }
    
    func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, indexTitleIn row: Int) -> String {
        let seats = self.seats[row]
        return "\((seats.count>0 ? "\(row)" : ""))"
    }
    
}

