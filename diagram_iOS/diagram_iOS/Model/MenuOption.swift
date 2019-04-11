//
//  MenuOption.swift
//  diagram_iOS
//
//  Created by Gaurav Pai on 23/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible{
    case Save
    case SaveAs
    case Screenshot
    case ExportPDF
    
    var description: String
    {
        switch self
        {
        case .Save: return "Save"
        case .SaveAs: return "Save As"
        case .Screenshot: return "Screenshot"
        case .ExportPDF: return "Export as PDF"
        }
    }
    
    var image: UIImage{
        switch self {
        case .Save: return UIImage(named: "saveas") ?? UIImage()
        case .SaveAs: return UIImage(named: "save") ?? UIImage()
        case .Screenshot: return UIImage(named: "screenshot") ?? UIImage()
        case .ExportPDF: return UIImage(named: "profile") ?? UIImage()
        }
    }
}
