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
        scaler(view: self)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        //        pdfContext.scaleBy(x: 1/8, y: 1/8)
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData, name: forName)
        
    }
    
    func exportAsImage(){
        //scaler(view: self)
        // Create the image context to draw in
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Get that context
        // Draw the image view in the context
        defer { UIGraphicsEndImageContext() }
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // You may or may not need to repeat the above with the imageView's subviews // Then you grab the "screenshot" of the context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // Be sure to end the context
        
        UIGraphicsEndImageContext()
        //
        //        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        //        //self.layer.contentsScale = 8
        //        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func scaler(view: UIView) {
        //        view.layer.contentsScale = 8
        view.contentScaleFactor = 8
        for subView in view.subviews {
            scaler(view: subView)
        }
        //        let subLayerArray = view.layer.sublayers
        //        for subLayer in subLayerArray ?? []{
        //            subLayer.contentsScale = 8
        //        }
    }
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData, name: String) -> String {
        let file = FileHandling(name: "")
        let pdfPath = file.getURL(for: .Project).appendingPathComponent(name+".pdf")
        print(pdfPath)
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return "Error writing pdf"
        }
    }
}
