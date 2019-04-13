//
//  DemoView.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 12/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class processView: UIView , UIGestureRecognizerDelegate {
    
    var shape: String?
    
    
    
    
    
    var kResizeThumbSize : CGFloat = 45.0
    var isResizingLR = false
    var isResizingUL = false
    var isResizingUR = false
    var isResizingLL = false
    var touchStart = CGPoint.zero
    let borderlayer = CAShapeLayer()
    let textView = UITextView()
//    let textLabel = UITextField()
    var circles = [CircleView]()
    var delete : CircleView?
    var processID : Int?
    var myText :String?
    var resizeDelegate : resizeDropzoneDelegate?
    
   
    //    let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
    
    
    var path: UIBezierPath!
    var main_layer: CAShapeLayer!
    
    convenience init(frame: CGRect, ofShape: String, withID id: Int, withText text: String) {
        self.init(frame: frame)
        self.myText = text
        self.shape = ofShape
        self.processID = id
        createShape()
        //create a text view at the center
        createTextView(text: self.myText ?? "Insert Text")
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.isExclusiveTouch = true
        //gesture to recognize double tap to disable resize
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        gestureRecognizer.numberOfTapsRequired = 2
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)
        self.backgroundColor = UIColor.clear
        
        //allign the frame to the grid
        let new_frame = CGRect(x: self.frame.origin.x.rounded(to: 50)-10, y: self.frame.origin.y.rounded(to: 50)-10, width: self.frame.width.rounded(to: 50)+20, height :self.frame.height.rounded(to: 50)+20)
        self.frame = new_frame
        
        //animated border
        let bounds = self.bounds
        borderlayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        borderlayer.strokeColor = UIColor.black.cgColor
        borderlayer.fillColor = nil
        borderlayer.lineDashPattern = [8, 6]
//        borderlayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        self.layer.addSublayer(borderlayer)
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = borderlayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        borderlayer.add(animation, forKey: "line")
        
        
        
        
        //createTextLayer()
        
        
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        //    For NSCoding
        //        aCoder.encode(title, forKey: Keys.title.rawValue)
        //        aCoder.encode(rating, forKey: Keys.rating.rawValue)
        
    }
    
    
    
    func createRectangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 10.0, y: 10.0))
        path.addLine(to: CGPoint(x: 10.0, y: self.frame.size.height - 10))
        path.addLine(to: CGPoint(x: self.frame.size.width - 10, y: self.frame.size.height - 10))
        path.addLine(to: CGPoint(x: self.frame.size.width - 10, y: 10.0))
        path.close()
    }
    
    func createDiamond() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: 10))
        path.addLine(to: CGPoint(x: 10 , y: self.frame.height/2))
        path.addLine(to: CGPoint(x: self.frame.width/2 , y: self.frame.height - 10))
        path.addLine(to: CGPoint(x: self.frame.width - 10, y: self.frame.height/2))
        path.close()
    }
    
    func createTriangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: 10))
        path.addLine(to: CGPoint(x: 10, y: self.frame.size.height - 10))
        path.addLine(to: CGPoint(x: self.frame.size.width - 10 , y: self.frame.size.height - 10))
        path.close()
    }
    
    
    func createRoundedRectangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 40, y: 10))
        path.addLine(to: CGPoint(x: self.frame.width - 40, y: 10))
        path.addCurve(to: CGPoint(x: self.frame.width - 40, y: self.frame.height - 10), controlPoint1: CGPoint(x: self.frame.width, y: (self.frame.height)/3), controlPoint2: CGPoint(x: self.frame.width, y: 2*(self.frame.height)/3))
        path.addLine(to: CGPoint(x: 40, y: self.frame.height - 10))
        path.addCurve(to: CGPoint(x: 40, y: 10), controlPoint1: CGPoint(x: 0, y: 2*(self.frame.height)/3), controlPoint2: CGPoint(x: 0, y:     (self.frame.height)/3))
        path.close()
    }
    
    func createDatabase() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 20))
        path.addCurve(to: CGPoint(x: self.frame.width - 10, y: 20), controlPoint1: CGPoint(x: self.frame.width/3, y: 0), controlPoint2: CGPoint(x: 2*self.frame.width/3, y: 0))
        path.addCurve(to: CGPoint(x: 10, y: 20), controlPoint1: CGPoint(x: self.frame.width*2/3, y: 40), controlPoint2: CGPoint(x: self.frame.width/3, y: 40))
        path.addLine(to: CGPoint(x: 10, y: self.frame.height - 20))
        path.addCurve(to: CGPoint(x: self.frame.width - 10, y: self.frame.height - 20), controlPoint1: CGPoint(x: self.frame.width/3, y: self.frame.height), controlPoint2: CGPoint(x: self.frame.width*2/3, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width - 10, y: 20))
        
    }
    
    func createHarddisk(){
        path = UIBezierPath()
        //path.move(to: CGPoint(x: 20, y: 10))
        path.move(to: CGPoint(x: self.frame.width - 20, y: 10))
        path.addCurve(to: CGPoint(x: self.frame.width - 20, y: self.frame.height - 10), controlPoint1: CGPoint(x: self.frame.width, y: self.frame.height/3), controlPoint2: CGPoint(x: self.frame.width, y: self.frame.height*2/3))
        path.addCurve(to: CGPoint(x: self.frame.width - 20, y: 10), controlPoint1: CGPoint(x: self.frame.width - 40, y: self.frame.height*2/3), controlPoint2: CGPoint(x: self.frame.width - 40, y: self.frame.height/3))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.addCurve(to: CGPoint(x: 20, y: self.frame.height - 10), controlPoint1: CGPoint(x: 0, y: self.frame.height/3), controlPoint2: CGPoint(x: 0, y: self.frame.height*2/3))
        path.addLine(to: CGPoint(x: self.frame.width - 20, y: self.frame.height - 10))
    }
    
    
    
    
    
    func createTextView(text: String) {
        
        textView.text = text
        textView.frame = CGRect(x: 0.0, y: self.frame.size.height/2 - 20.0, width: self.frame.size.width, height: 40.0)
        textView.frame = textView.frame.integral
        //        textView.frame = CGRect(x: 20.0, y: 20.0, width: self.bounds.size.width - 20, height: self.bounds.size.height - 20.0)
        textView.textAlignment = NSTextAlignment.center
        textView.backgroundColor = UIColor.clear
        textView.font = textView.font?.withSize(18)
        
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        textView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        //textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.maximumNumberOfLines = 3
        //        textView.isScrollEnabled = false
        //textView.textContainer.exclusionPaths = [path]

        textView.layer.contentsScale = 10
        self.addSubview(textView)
        
    }
    
//    func createTextView_1() {
//
//        textLabel.text = "Hello"
//        textLabel.frame = CGRect(x: 0.0, y: self.frame.size.height/2 - 20.0, width: self.frame.size.width, height: 40.0)
//        //        textView.frame = CGRect(x: 20.0, y: 20.0, width: self.bounds.size.width - 20, height: self.bounds.size.height - 20.0)
//        textLabel.textAlignment = NSTextAlignment.center
//        textLabel.backgroundColor = UIColor.clear
//        textLabel.isUserInteractionEnabled = true
//        textLabel.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
//        //        textLabel = 2
//        textLabel.sizeToFit()
//        //        textLabel.lines
//        //        textLabel.textContainer.exclusionPaths = [path]
//        self.addSubview(textLabel)
//    }
    
//
//    func createTextLayer() {
//        let textLayer = CATextLayer()
//        textLayer.string = "WOW!\nThis is text on a layer!"
//        textLayer.foregroundColor = UIColor.white.cgColor
//        textLayer.font = UIFont(name: "Avenir", size: 15.0)
//        textLayer.fontSize = 15.0
//        textLayer.alignmentMode = CATextLayerAlignmentMode.center
//        textLayer.backgroundColor = UIColor.orange.cgColor
//        textLayer.frame = CGRect(x: 0.0, y: self.frame.size.height/2 - 20.0, width: self.frame.size.width, height: 40.0)
//        textLayer.contentsScale = UIScreen.main.scale
//        self.layer.addSublayer(textLayer)
//    }
    
    
    func createCircles(_ id1: Int, _ id2: Int, _ id3: Int,  _ id4: Int){
        let cir1 = CircleView(frame: CGRect(x: self.center.x - (self.bounds.size.width / 2) - 40 , y: self.center.y - 20, width: 40, height: 40), isSide: sides.left.rawValue, withID: id1)//left
        let cir2 = CircleView(frame: CGRect(x: self.center.x - 20 , y: self.center.y - (self.bounds.size.height / 2) - 40, width: 40, height: 40), isSide: sides.top.rawValue, withID: id2)
        let cir3 = CircleView(frame: CGRect(x: self.center.x + (self.bounds.size.width / 2) , y: self.center.y - 20, width: 40, height: 40), isSide: sides.right.rawValue, withID: id3)
        let cir4 = CircleView(frame: CGRect(x: self.center.x - 20 , y: self.center.y + (self.bounds.size.height / 2) , width: 40, height: 40), isSide: sides.bottom.rawValue, withID: id4)
        
        cir1.mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 2) , y: self.center.y)
        cir2.mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2))
        cir3.mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 2) , y: self.center.y)
        cir4.mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2))
        cir1.myView = self
        cir2.myView = self
        cir3.myView = self
        cir4.myView = self
        cir1.backgroundColor = .clear
        cir2.backgroundColor = .clear
        cir3.backgroundColor = .clear
        cir4.backgroundColor = .clear
        //        circles.append(cir1,cir2,cir3,cir4)
        self.circles.append(contentsOf: [cir1,cir2,cir3,cir4])
        superview?.addSubview(cir1)
        superview?.addSubview(cir2)
        superview?.addSubview(cir3)
        superview?.addSubview(cir4)
        
        let del = CircleView(frame: CGRect(x: self.center.x - (self.bounds.size.width / 2) - 40 , y: self.center.y - (self.bounds.size.height / 2) - 40, width: 40, height: 40), isDelete: true)
        del.myView = self
        del.backgroundColor = .clear
        self.delete = del
        superview?.addSubview(del)
        
    }
    
    func update_circle_views(){
        circles[0].center = CGPoint(x: self.center.x - (self.bounds.size.width / 2) - 20 , y: self.center.y)
        circles[1].center = CGPoint(x: self.center.x, y: self.center.y - (self.bounds.size.height / 2) - 20)
        circles[2].center = CGPoint(x: self.center.x + (self.bounds.size.width / 2) + 20 , y: self.center.y)
        circles[3].center = CGPoint(x: self.center.x, y: self.center.y + (self.bounds.size.height / 2) + 20)
        delete?.center = CGPoint(x: self.center.x - (self.bounds.size.width / 2) - 20 , y: self.center.y - (self.bounds.size.height / 2) - 20)
        
        
        circles[0].mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 2) , y: self.center.y)
        circles[1].mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2))
        circles[2].mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 2) , y: self.center.y)
        circles[3].mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2))
        
        for circle in circles{
            if let _ = circle.outGoingCircle, let line = circle.outGoingLine, let _ = circle.outGoingLine?.path {
                line.path = circle.getPath(circle: circle.outGoingCircle!)
                line.thinArrow.path = circle.getPath(circle: circle.outGoingCircle!, getAlternate: true)
            }
            
            if let _ = circle.inComingCircle, let line = circle.inComingLine, let _ = circle.inComingLine?.path {
                line.path = circle.inComingCircle!.getPath(circle: circle)
                line.thinArrow.path = circle.inComingCircle!.getPath(circle: circle, getAlternate: true)
            }
        }
    }
    
    func update_main_layer(){
        if self.shape == "triangle" {
            self.createTriangle()
        }else if self.shape == "rhombus"{
            self.createDiamond()
        }else if self.shape == "rounded rectangle"{
            self.createRoundedRectangle()
        }else if self.shape == "rectangle"{
            self.createRectangle()
        }else if self.shape == "database"{
            self.createDatabase()
        }else if self.shape == "harddisk"{
            self.createHarddisk()
        }
        
        main_layer.path = path.cgPath
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func createShape() {
//        print("drawing here")
        // Drawing code
        if self.shape == "triangle" {
            self.createTriangle()
        }else if self.shape == "rhombus"{
            self.createDiamond()
        }else if self.shape == "rounded rectangle"{
            self.createRoundedRectangle()
        }else if self.shape == "rectangle"{
            self.createRectangle()
        }else if self.shape == "database"{
            self.createDatabase()
        }else if self.shape == "harddisk"{
            self.createHarddisk()
        }
        
        main_layer = CAShapeLayer()
        main_layer.path = path.cgPath
        main_layer.lineWidth = 3.0
        main_layer.strokeColor = UIColor.black.cgColor
        main_layer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(main_layer)
        //        if let context = UIGraphicsGetCurrentContext(){
        //
        //            context.setLineWidth(3.0)
        //            context.setStrokeColor(UIColor.black.cgColor)
        ////            context.setFillColor(UIColor.orange.cgColor)
        ////            context.addPath(path.cgPath)
        //            context.move(to: CGPoint(x: 10.0, y: 10.0))
        //            context.addLine(to: CGPoint(x: 10.0, y: self.frame.size.height - 10))
        //            context.addLine(to: CGPoint(x: self.frame.size.width - 10, y: self.frame.size.height - 10))
        //            context.addLine(to: CGPoint(x: self.frame.size.width - 10, y: 10.0))
        //            context.closePath()
        //            context.strokePath()
        ////            UIColor.black.setStroke()
        ////            path.stroke()
        //        }
        
        
        //            else{
        //            UIColor.clear.setFill()
        //            path.fill()
        //            // Specify a border (stroke) color.
        //            UIColor.black.setStroke()
        //            path.stroke()
        //        }
        //        let layer = CAShapeLayer()
        //        layer.path = self.path.cgPath
        //        layer.lineWidth = 4.0
        //        layer.fillColor =  UIColor.clear.cgColor
        //        layer.strokeColor = UIColor.black.cgColor
        //        self.layer.addSublayer(layer)
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let scroll = self.superview?.superview as! UIScrollView
        //        scroll.isScrollEnabled = false
        //see if the resize has to happen, if so in which direction.
        self.textView.resignFirstResponder()
        self.alpha = 0.2
        self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
//        self.frame = CGRect(x: self.frame.origin.x - 20, y: self.frame.origin.y - 20, width: self.frame.width + 40, height: self.frame.height + 40)
        //        if self.borderlayer.isHidden{
        //            return
        //        }
        let touch = touches.first
        //print("Touchesbegan")
        self.touchStart = touch!.location(in: self)
        //print("\(self.bounds.size.width) \(self.bounds.size.height) \(touchStart.x) \(touchStart.y)")
        if (self.bounds.size.width - touchStart.x < kResizeThumbSize) && (self.bounds.size.height - touchStart.y < kResizeThumbSize){
            isResizingLR = true
        }else{
            isResizingLR = false
        }
        if (touchStart.x < kResizeThumbSize && touchStart.y < kResizeThumbSize){
            isResizingUL = true
        }else{
            isResizingUL = false
        }
        
        if (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize){
            isResizingUR = true
        }else{
            isResizingUR = false
        }
        if (touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize){
            isResizingLL = true
        }else{
            isResizingLL = false
        }
        //print("\(isResizingLL) \(isResizingLR) \(isResizingUL) \(isResizingUR)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        print("touched ended")
        //        let midPoint = self.center.rounded(to: 50)
        //
        //        self.center = midPoint
        self.alpha = 1
        self.transform = CGAffineTransform.identity
        let new_frame = CGRect(x: self.frame.origin.x.rounded(to: 50)-10, y: self.frame.origin.y.rounded(to: 50)-10, width: self.frame.width.rounded(to: 50)+20, height :self.frame.height.rounded(to: 50)+20)
        self.frame = new_frame
        
        self.subviews[0].center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.borderlayer.path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        update_main_layer()
        update_circle_views()
        

        //        let scroll = self.superview?.superview as! UIScrollView
        //        scroll.isScrollEnabled = true
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let scroll = self.superview?.superview as! UIScrollView
        //        scroll.isScrollEnabled = true
        self.alpha = 1
        self.transform = CGAffineTransform.identity
    }
    
    //handle the resize, pan and move all the view appropriately
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touches moved")
        let touchPoint =  touches.first?.location(in: self)
        let previous = touches.first?.previousLocation(in: self)
        
        let deltaWidth = (touchPoint?.x)! - (previous?.x)!
        let deltaHeight = (touchPoint?.y)! - (previous?.y)!
        
        let x : CGFloat = self.frame.origin.x
        let y : CGFloat = self.frame.origin.y
        let width : CGFloat = self.frame.size.width
        let height : CGFloat = self.frame.size.height
        if self.borderlayer.isHidden{
            self.center = CGPoint(x: self.center.x + touchPoint!.x - touchStart.x, y: self.center.y + touchPoint!.y - touchStart.y)
            self.subviews[0].center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            self.borderlayer.path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
            update_circle_views()
            resizeDelegate?.resizeDropZone()
            //            let scroll = self.superview?.superview as! UIScrollView
            //            scroll.isScrollEnabled = true
            return
        }
        
        
        
        
        if (isResizingLR) {
            self.frame = CGRect(x: x, y: y, width: touchPoint!.x+deltaWidth, height :touchPoint!.y+deltaWidth)
        } else if (isResizingUL) {
            self.frame = CGRect(x: x+deltaWidth, y: y+deltaHeight,width: width-deltaWidth,height:  height-deltaHeight)
        } else if (isResizingUR) {
            self.frame = CGRect(x: x, y: y+deltaHeight, width: width+deltaWidth, height: height-deltaHeight)
        } else if (isResizingLL) {
            self.frame = CGRect(x: x+deltaWidth, y: y, width: width-deltaWidth, height: height+deltaHeight)
        } else {
            // not dragging from a corner -- move the view
            self.center = CGPoint(x: self.center.x + touchPoint!.x - touchStart.x, y: self.center.y + touchPoint!.y - touchStart.y)
            //            self.center = touches.first!.location(in: self.superview)
        }
        update_main_layer()
        
        self.subviews[0].center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.borderlayer.path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        update_circle_views()
        resizeDelegate?.resizeDropZone()

        
        //        let scroll = self.superview?.superview as! UIScrollView
        //        scroll.isScrollEnabled = true
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        print("touches moved")
    //        let touch = touches.first
    //        self.center = touch!.location(in: self.superview)
    //    }
    
    
    
    func disable_resize() {
        self.borderlayer.isHidden = true
        self.textView.isUserInteractionEnabled = false
        for circle in circles{
            circle.isHidden = true
        }
        self.delete?.isHidden = true
    }
    
    func enable_resize() {
        self.borderlayer.isHidden = false
        self.textView.isUserInteractionEnabled = true
        for circle in circles{
            if !circle.hasConnection{
                circle.isHidden = false
            }
        }
        self.delete?.isHidden = false
    }
    
    //double tap to enable/disable resize
    @objc func myTapAction(_ sender: UITapGestureRecognizer) {
        
        if self.borderlayer.isHidden {
            enable_resize()
        }
        else{
            disable_resize()
        }
        
    }
    
    
    
}
