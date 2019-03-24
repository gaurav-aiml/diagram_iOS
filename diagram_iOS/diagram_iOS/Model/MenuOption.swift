//
//  MenuOption.swift
//  diagram_iOS
//
//  Created by Gaurav Pai on 23/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible{
    case Profile
    case Load
    case SaveAs
    case Save
    case Screenshot
    case Recents
    
    var description: String
    {
        switch self
        {
        case .Profile: return "Profile"
        case .Load: return "Load"
        case .SaveAs: return "Save As"
        case .Save: return "Save"
        case .Screenshot: return "Screenshot"
        case .Recents: return "Recents"
        
        }
    }
    
    var image: UIImage{
        switch self {
        case .Profile: return UIImage(named: "profile") ?? UIImage()
        case .Load: return UIImage(named: "load") ?? UIImage()
        case .SaveAs: return UIImage(named: "saveas") ?? UIImage()
        case .Save: return UIImage(named: "save") ?? UIImage()
        case .Screenshot: return UIImage(named: "screenshot") ?? UIImage()
        case .Recents: return UIImage(named: "recent") ?? UIImage()
        }
    }
}
