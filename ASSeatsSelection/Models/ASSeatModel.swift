//
//  ASSeatModel.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

/// seat state
///
/// - edge: is edge, can't be touched
/// - sold: is sold, can't be touched
/// - available: can be touched
/// - selected: is selected, can be touched
public enum ASSeatState: Int {
    case edge
    
    case sold
    
    case available
    
    case selected
    
}

class ASSeatModel: NSObject {
    var row: String?
    var column: String?
    var imageUrl: String?
    var type: ASSeatState = .edge
}
