//
//  CircleView.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 14/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class CircleView : UIView , UIGestureRecognizerDelegate {
    
    var outGoingLine : CAShapeLayer?
    var inComingLine : CAShapeLayer?
    var inComingCircle : CircleView?
    var outGoingCircle : CircleView?
    var mainPoint : CGPoint?
    var hasConnection : Bool
    var myView : processView?
    var isDelete : Bool?
    let myLayer = CALayer()
    var side: Int?
    static var uniqueID = 0
    
    


    
    convenience init(frame: CGRect, isDelete: Bool) {
        self.init(frame: frame)
        self.isDelete = isDelete
        if self.isDelete!{
            let myImage = UIImage(named: "delete")?.cgImage
            myLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            myLayer.contents = myImage
        }
    }
    
    convenience init(frame: CGRect, isSide: Int) {
        self.init(frame: frame)
        self.side = isSide
    }
    
    override init(frame: CGRect) {
        hasConnection = false
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.width / 2
//        let plus = UIImageView(image: UIImage(contentsOfFile: "plus"))
//        plus.frame = self.frame
//        plus.contentMode = .sca
//        self.addSubview(plus)
        let myImage = UIImage(named: "plus")?.cgImage
        myLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        myLayer.contents = myImage
        self.layer.addSublayer(myLayer)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lineTo2(circle: CircleView) -> CAShapeLayer {
        let path = UIBezierPath()
//        path.move(to: self.center)
//        path.addLine(to: circle.center)
        path.move(to: (self.mainPoint)!)
        path.addLine(to: (circle.mainPoint)!)
        
        let line = CAShapeLayer()
        line.path = path.cgPath
        line.lineWidth = 2
        line.strokeColor = UIColor.black.cgColor

        circle.inComingLine = line
        outGoingLine = line
        outGoingCircle = circle
        circle.inComingCircle = self
        return line
    }
    
    
    
    
    func lineTo(circle: CircleView) -> CAShapeLayer {
        let arrow = UIBezierPath.arrow(from: (self.mainPoint)!, to: (circle.mainPoint)!,tailWidth: 2, headWidth: 8, headLength: 15)
        //let arrow = UIBezierPath.arrow2(from: (self.mainPoint)!, to: (circle.mainPoint)!, circle1: self, circle2: circle)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = arrow.cgPath
        circle.inComingLine = shapeLayer
        outGoingLine = shapeLayer
        outGoingCircle = circle
        circle.inComingCircle = self
        self.hasConnection = true
        self.isHidden = true
        circle.hasConnection = true
        circle.isHidden = true
        return shapeLayer
    }
    
    
    
    func getPath(circle: CircleView) -> CGPath {
        let arrow = UIBezierPath.arrow(from: (self.mainPoint)!, to: (circle.mainPoint)!,tailWidth: 2, headWidth: 8, headLength: 15)
        //let arrow = UIBezierPath.arrow2(from: (self.mainPoint)!, to: (circle.mainPoint)!, circle1: self, circle2: circle)
        return arrow.cgPath
    }
    
    
    
    static func getUniqueID() -> Int{
        uniqueID += 1
        return uniqueID
    }
}




