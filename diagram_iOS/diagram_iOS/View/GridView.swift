//
//  GridView.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 23/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    var numberOfColumns: Int = 20
    var numberOfRows: Int = 20
    var lineWidth: CGFloat = 1.0
    var lineColor: UIColor = UIColor.white
    var path1 : UIBezierPath!
    var path2 : UIBezierPath!
    
    
    override func draw(_ rect: CGRect) {
        numberOfRows = Int(self.frame.height/50)
        numberOfColumns = Int(self.frame.width/50)
        path1 = UIBezierPath()
        path2 = UIBezierPath()
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setLineWidth(lineWidth)
            context.setStrokeColor(#colorLiteral(red: 0.8529897541, green: 0.8529897541, blue: 0.8529897541, alpha: 1))
            
            //            let columnWidth = Int(rect.width) / (numberOfColumns + 1)
            let columnWidth = 50
            
            for i in 1...numberOfColumns {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = CGFloat(columnWidth * i)
                startPoint.y = 0.0
                endPoint.x = startPoint.x
                endPoint.y = frame.size.height
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
            
            //            let rowHeight = Int(rect.height) / (numberOfRows + 1)
            let rowHeight = 50
            
            for j in 1...numberOfRows {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = 0.0
                startPoint.y = CGFloat(rowHeight * j)
                endPoint.x = frame.size.width
                endPoint.y = startPoint.y
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
        }
        //        drawGrid()
        //        UIColor.black.setStroke()
        //        UIColor.clear.setFill()
        //        path1.stroke()
        //        path1.fill()
        //        path2.stroke()
        //        path2.fill()
    }
    
    
    
    func drawGrid(){
        
        let columnWidth = Int(self.frame.width) / (numberOfColumns + 1)
        for i in 1...numberOfColumns {
            var startPoint = CGPoint.zero
            var endPoint = CGPoint.zero
            startPoint.x = CGFloat(columnWidth * i)
            startPoint.y = 0.0
            endPoint.x = startPoint.x
            endPoint.y = frame.size.height
            path1.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
            path1.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        }
        
        let rowHeight = Int(self.frame.height) / (numberOfRows + 1)
        for j in 1...numberOfRows {
            var startPoint = CGPoint.zero
            var endPoint = CGPoint.zero
            startPoint.x = 0.0
            startPoint.y = CGFloat(rowHeight * j)
            endPoint.x = frame.size.width
            endPoint.y = startPoint.y
            path2.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
            path2.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        }
    }
}

