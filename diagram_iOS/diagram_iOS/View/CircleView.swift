//
//  CircleView.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 14/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class CircleView : UIView , UIGestureRecognizerDelegate {
    
    var outGoingLine : ArrowShape?
    var inComingLine : ArrowShape?
    var inComingCircle : CircleView?
    var outGoingCircle : CircleView?
    var mainPoint : CGPoint?
    var hasConnection : Bool{
        didSet{
            self.isHidden = self.hasConnection
        }
    }
    var myView : processView?
    var myLayer : ArrowShape?
    var isDelete : Bool?
    let imageLayer = CALayer()
    var side: Int?
    static var uniqueID = 0
    var circleID: Int?
    
    convenience init(frame: CGRect, isDelete: Bool) {
        self.init(frame: frame)
        self.isDelete = isDelete
        if self.isDelete!{
            let myImage = UIImage(named: "delete")?.cgImage
            imageLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            imageLayer.contents = myImage
        }
    }
    
    convenience init(frame: CGRect, isExpand: Bool) {
        self.init(frame: frame)
        if isExpand{
            let myImage = UIImage(named: "expand")?.cgImage
            imageLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            imageLayer.contents = myImage
        }
    }
    
    convenience init(frame: CGRect, ofType type: String) {
        self.init(frame: frame)
        var myImage: CGImage?
        if type == "expand"{
            myImage = UIImage(named: "expand")?.cgImage
        }
        else if type == "delete"{
            myImage = UIImage(named: "delete")?.cgImage
        }
        else if type == "ok"{
            myImage = UIImage(named: "ok")?.cgImage
        }
        else if type == "time"{
            myImage = UIImage(named: "time")?.cgImage
        }
        else if type == "bottleneck"{
            myImage = UIImage(named: "bottleneck")?.cgImage
        }
        imageLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageLayer.contents = myImage
    }
    
    convenience init(frame: CGRect, isSide: Int, withID id: Int) {
        self.init(frame: frame)
        self.circleID = id
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
        imageLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageLayer.contents = myImage
        self.layer.addSublayer(imageLayer)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

    

    
    func lineTo(circle: CircleView) -> ArrowShape {
        let points = ArrowShape.getArrowpoints(inSide: self.side ?? 10, outSide: circle.side ?? 10, from: self, to: circle)
        //        let arrow = UIBezierPath.arrow(from: (self.mainPoint)!, to: (circle.mainPoint)!,tailWidth: 20, headWidth: 40, headLength: 20)
        //        let arrow = UIBezierPath.arrow2(from: (self.mainPoint)!, to: (circle.mainPoint)!, circle1: self, circle2: circle)
        
        let (arrow, midPoint, isHorizontal) = UIBezierPath.arrow3(points: points,tailWidth: 10, headWidth: 10, headLength: 30)
        let shapeLayer = ArrowShape(withPoint: midPoint, inputCircle: self, outputCircle: circle)
        let (arrow2, _, _) = UIBezierPath.arrow3(points: points,tailWidth: 1, headWidth: 3, headLength: 5)
        shapeLayer.alternatePath = arrow2.cgPath
        shapeLayer.path = arrow.cgPath
        shapeLayer.midPoint = midPoint
        shapeLayer.isHorizontal = isHorizontal
        circle.inComingLine = shapeLayer
        outGoingLine = shapeLayer
        outGoingCircle = circle
        circle.inComingCircle = self
        self.hasConnection = true
        //        self.isHidden = true
        circle.hasConnection = true
        //        circle.isHidden = true
        
        return shapeLayer
        
    }
    
    
    
    func getPath(circle: CircleView, getAlternate: Bool = false) -> CGPath {
        let points = ArrowShape.getArrowpoints(inSide: self.side ?? 10, outSide: circle.side ?? 10, from: self, to: circle)
        if getAlternate {
            let (arrow, midPoint, isHorizontal) = UIBezierPath.arrow3(points: points,tailWidth: 1, headWidth: 3, headLength: 5)
            //outGoingLine?.updateViews(withPoint: outGoingLine?.midPoint ?? self.mainPoint!)
            outGoingLine?.midPoint = midPoint
            outGoingLine?.isHorizontal = isHorizontal
            //        let arrow = UIBezierPath.arrow2(from: (self.mainPoint)!, to: (circle.mainPoint)!, circle1: self, circle2: circle)
            return arrow.cgPath
        }
        let (arrow, midPoint, isHorizontal) = UIBezierPath.arrow3(points: points,tailWidth: 10, headWidth: 10, headLength: 30)
        //outGoingLine?.updateViews(withPoint: outGoingLine?.midPoint ?? self.mainPoint!)
        outGoingLine?.midPoint = midPoint
        outGoingLine?.isHorizontal = isHorizontal
        return arrow.cgPath
        
    }
    

    
    
    
    static func getUniqueID() -> Int{
        uniqueID += 1
        return uniqueID
    }
    
    
}


