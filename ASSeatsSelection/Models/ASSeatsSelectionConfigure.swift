//
//  ASSeatsSelectionConfigure.swift
//  ASSeatsSelection
//
//  Created by Ashoka on 19/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

typealias ASSeatsSelectionConfigure = [ASSeatsSelectionConfigurationItem]

public enum ASSeatsSelectionConfigurationItem {
    case indicatorConfiguration(IndicatorConfiguration)
    case hallLogoConfiguration(HallLogoConfiguration)
    case rowIndexConfiguration(RowIndexConfiguration)
    case centerLineConfiguration(CenterLineConfiguration)
}

public enum IndicatorConfiguration {
    case indicatorBorderColor(UIColor)
    case indicatorViewHeight(CGFloat)
}

public enum HallLogoConfiguration {
    case hallLogoSize(CGSize)
    case hallLogoImage(UIImage)
    case hallName(String)
    case hallNameColor(UIColor)
    case isHallLogoHidden(Bool)
}

public enum RowIndexConfiguration {
    case backgroundColor(UIColor)
    case titleColor(UIColor)
}

public enum CenterLineConfiguration {
    case lineColor(UIColor)
    case lineWidth(CGFloat)
    case isHiddenLine(ASCenterLineDirection, Bool)
}
