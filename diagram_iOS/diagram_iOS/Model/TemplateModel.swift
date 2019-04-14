//
//  TemplateModel.swift
//  diagram_iOS
//
//  Created by Gaurav Pai on 13/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import Foundation

enum templateItems: Int, CaseIterable {
    case FromFormat
    case IssueNo
    case RevNo
    case CustName
    case ProjectName
    case IPCAccCrit
    case ProdName
    case ProdPartNo
    case ProdRevNo
    case PFDNo
    case PFDRevNo
    case RevDate
    
    var description: String
    {
        switch self
        {
        case .FromFormat:
            return "Form Format"
        case .IssueNo:
            return "Issue No."
        case .RevNo:
            return "Revision No."
        case .CustName:
            return "Customer Name"
        case .ProjectName:
            return "Project Name"
        case .IPCAccCrit:
            return "IPC Acceptance Criteria"
        case .ProdName:
            return "Product Name"
        case .ProdPartNo:
            return "Product Part No."
        case .ProdRevNo:
            return "Product Revision No."
        case .PFDNo:
            return "PFD No."
        case .PFDRevNo:
            return "PFD Rev No."
        case .RevDate:
            return "Revision Date"
        }
    }
}
