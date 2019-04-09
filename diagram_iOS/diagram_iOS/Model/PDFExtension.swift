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
    func exportAsPdfFromView() -> String {
        scaler(v: self)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
//        pdfContext.scaleBy(x: 1/8, y: 1/8)
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData)
        
    }
    
    func exportAsImage(){
        scaler(v: self)
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 8)
        self.layer.contentsScale = 8
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func scaler(v: UIView) {
        v.contentScaleFactor = 8
        for sv in v.subviews {
            scaler(v: sv)
        }
    }
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
