//
//  pdfextension.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 17/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

extension UIView {
    
    // Export pdf from Save pdf in drectory and return pdf file path
    func exportAsPdfFromView(name forName: String) -> String {
        scaler(v: self)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.width*8, height: self.bounds.height*8)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        pdfContext.scaleBy(x: 1/8, y: 1/8)
        self.layer.draw(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData, name: forName)
        
    }
    
    
    func scaler(v: UIView) {
            v.contentScaleFactor = 8
        
        for sv in v.subviews {
            scaler(v: sv)
        }
    }
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData, name: String) -> String {
        let file = FileHandling(name: "")
        let docDirectoryPath =  file.buildFullPath(forFileName: name, inDirectory: .Documents)
        let pdfPath = docDirectoryPath.appendingPathComponent(name+".pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
