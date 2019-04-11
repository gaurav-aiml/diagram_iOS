//
//  ArrowShape.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 26/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class ArrowShape: CAShapeLayer, UIGestureRecognizerDelegate {
    //    var point: CGPoint?{
    //        didSet{
    //            setNeedsDisplay()
    //        }
    //    }
    var circle: CircleView?
    var delete: CircleView?
    var expand: CircleView?
    var ok: CircleView?
    var time: CircleView?
    //    var id: Int?
    var subView: UIView?
    var viewsHidden: Bool!
    var inputCircle: CircleView!
    var outputCircle: CircleView!
    var midPoint: CGPoint!{
        didSet{
            self.okTextField?.center = midPoint
            self.timeTextField?.center = CGPoint(x: self.midPoint.x, y: self.midPoint.y - 40)
            updateViews(withPoint: midPoint)
        }
    }
    var isHorizontal: Bool!
    var okTextField : UILabel!
    var timeTextField : UILabel!
    var isExpanded: Bool!{
        didSet{
            if isExpanded == true{
                self.strokeColor = UIColor.black.cgColor
                thinArrow.strokeColor = UIColor.clear.cgColor
                thinArrow.fillColor = UIColor.clear.cgColor
            }
            else{
                self.strokeColor = UIColor.clear.cgColor
                thinArrow.strokeColor = UIColor.black.cgColor
                thinArrow.fillColor = UIColor.black.cgColor
            }
        }
    }
    
    
    var mainPath: CGPath!{
        didSet{
            self.path = mainPath
            //            self.strokeColor = mainStroke
            //            self.fillColor = mainFill
        }
    }
    var alternatePath: CGPath!{
        didSet{
            thinArrow?.path = alternatePath
        }
    }
    
    var setAlternatePath = false
    var thinArrow: CAShapeLayer!
    var arrowID: Int?
    
    
    override init() {
        print("init arrow")
        super.init()
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = UIColor.clear.cgColor
        self.lineWidth = 2.0
        self.isExpanded = false
        thinArrow = CAShapeLayer()
        thinArrow.path = alternatePath
        thinArrow.fillColor = UIColor.black.cgColor
        thinArrow.strokeColor = UIColor.black.cgColor
        thinArrow.lineWidth = 2.0
        self.addSublayer(thinArrow)
    }
    
    override init(layer: Any) {
        print("override init arrow")
        super.init(layer: layer)
        
        guard layer is ArrowShape else { return }
    }
    
    convenience init(withPoint point: CGPoint , inputCircle: CircleView, outputCircle: CircleView) {
        print("convenience init arrow")
        self.init()
        //        self.point = point
        self.viewsHidden = false
        self.inputCircle = inputCircle
        self.outputCircle = outputCircle
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func createCircles(_ id: Int){
        circle = CircleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), isSide: sides.onArrow.rawValue, withID: id)
        circle?.mainPoint = midPoint
        circle?.myLayer = self
        delete = CircleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), ofType: "delete")
        delete?.myLayer = self
        
        expand = CircleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), ofType: "expand")
        ok = CircleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), ofType: "ok")
        time = CircleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), ofType: "time")
        
        updateViews(withPoint: midPoint)
        
        okTextField = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        okTextField.layer.borderColor = UIColor.black.cgColor
        okTextField.layer.borderWidth = 0.5
        okTextField.text = ""
        okTextField.textAlignment = .center
        okTextField.isOpaque = true
        okTextField.backgroundColor = UIColor.white
        okTextField.isHidden = true
        timeTextField = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        timeTextField.layer.borderColor = UIColor.black.cgColor
        timeTextField.layer.borderWidth = 0.5
        timeTextField.text = ""
        timeTextField.textAlignment = .center
        timeTextField.isOpaque = true
        timeTextField.backgroundColor = UIColor.white
        timeTextField.isHidden = true
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapExpand))
        tapGesture1.numberOfTapsRequired = 1
        tapGesture1.delegate = self
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tapOK))
        tapGesture2.numberOfTapsRequired = 1
        tapGesture2.delegate = self
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(tapTime))
        tapGesture3.numberOfTapsRequired = 1
        tapGesture3.delegate = self
        
        
        expand?.addGestureRecognizer(tapGesture1)
        ok?.addGestureRecognizer(tapGesture2)
        time?.addGestureRecognizer(tapGesture3)
        
        disable_resize()
        if self.subView != nil {
            self.subView?.addSubview(circle!)
            self.subView?.addSubview(delete!)
            self.subView?.addSubview(expand!)
            self.subView?.addSubview(ok!)
            self.subView?.addSubview(time!)
            self.subView?.addSubview(okTextField)
            timeTextField.resignFirstResponder()
            self.subView?.addSubview(timeTextField)
        }
    }
    
    
    @objc func tapExpand(_ sender: UITapGestureRecognizer){
        print("expand touched")
        if isExpanded == true{
            isExpanded = false
        }else{
            isExpanded = true
        }
        //        self.setAlternatePath = !self.setAlternatePath
        //        let tempPath = self.path
        //        self.path = alternatePath
        //        alternatePath  = tempPath
        setNeedsDisplay()
    }
    
    @objc func tapOK(_ sender: UITapGestureRecognizer){
        self.subView?.bringSubviewToFront(okTextField)
        if okTextField.text == ""{
            okTextField.isHidden = false
            okTextField.text = "OK"
            okTextField.sizeToFit()
            okTextField.center = midPoint
        }
        else if okTextField.text == "OK"{
            okTextField.isHidden = false
            okTextField.text = "NOT OK"
            okTextField.sizeToFit()
            okTextField.center = midPoint
        }
        else{
            okTextField.isHidden = true
            okTextField.text = ""
            okTextField.sizeToFit()
            okTextField.center = midPoint
        }
    }
    
    func setOkText(with text: String){
        if text != ""{
            okTextField.isHidden = false
            okTextField.text = text
            okTextField.sizeToFit()
            okTextField.center = midPoint
        }
        else{
            okTextField.isHidden = true
            okTextField.text = ""
            okTextField.sizeToFit()
            okTextField.center = midPoint
        }
    }
    
    func setTimeText(with text: String){
        if text != ""{
            timeTextField.isHidden = false
            timeTextField.text = text
            timeTextField.center = CGPoint(x: self.midPoint.x, y: self.midPoint.y - 40)
            timeTextField.sizeToFit()
            subView?.bringSubviewToFront(self.timeTextField)
        }
        else{
            self.timeTextField.isHidden = true
        }
    }
    
    @objc func tapTime(_ sender: UITapGestureRecognizer){
        print("Time gesture called")
        
        var topController = UIApplication.shared.keyWindow!.rootViewController as! UIViewController
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!;
        }
        
        topController.showInputDialog(title: "Add Time",
                                        subtitle: "Please enter the time below.",
                                        actionTitle: "Add",
                                        cancelTitle: "Cancel",
                                        inputPlaceholder: "Time in hours",
                                        inputKeyboardType: .numberPad)
        { (input:String?) in
            if input != ""{
                self.timeTextField.isHidden = false
                self.timeTextField.text = "\(input!) hours"
                self.timeTextField.sizeToFit()
                self.timeTextField.center = CGPoint(x: self.midPoint.x, y: self.midPoint.y - 40)
                self.subView?.bringSubviewToFront(self.timeTextField)
            }
            else{
                self.timeTextField.isHidden = true
            }
        }
        //        self.subView?.bringSubviewToFront(timeTextField)
        //        let alert = UIAlertController(title: "Enter time taken", message: nil, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //
        //        alert.addTextField(configurationHandler: { textField in
        //            textField.placeholder = "Time in mins"
        //        })
        //
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        //
        //            if let time = alert.textFields?.first?.text {
        //                self.timeTextField.text = time
        //                self.timeTextField.sizeToFit()
        //                if self.isHorizontal{
        //                    self.timeTextField.center = CGPoint(x: self.midPoint.x, y: self.midPoint.y - 40)
        //                }
        //                else{
        //                    self.timeTextField.center = CGPoint(x: self.midPoint.x, y: self.midPoint.y - 40)
        //                }
        //            }
        //        }))
        //
        //        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
    }
    
    func setSubView(_ view : UIView){
        self.subView = view
    }
    
    
    func updateViews(withPoint point: CGPoint){
        circle?.mainPoint = midPoint
        //        self.point = withPoint
        //        self.point = midPoint
        //        circle?.mainPoint = point
        if isHorizontal == false{
            circle?.center = CGPoint(x: point.x+30, y: point.y-20)
            delete?.center = CGPoint(x: point.x+70, y: point.y-20)
            expand?.center = CGPoint(x: point.x+110, y: point.y-20)
            ok?.center = CGPoint(x: point.x+50, y: point.y+20)
            time?.center = CGPoint(x: point.x+90, y: point.y+20)
        }
        else{
            circle?.center = CGPoint(x: point.x-40, y: point.y-80)
            delete?.center = CGPoint(x: point.x, y: point.y-80)
            expand?.center = CGPoint(x: point.x+40, y: point.y-80)
            ok?.center = CGPoint(x: point.x-20, y: point.y-40)
            time?.center = CGPoint(x: point.x+20, y: point.y-40)
        }
    }
    
    func removeEverything(){
        self.circle?.removeFromSuperview()
        self.delete?.removeFromSuperview()
        self.expand?.removeFromSuperview()
        self.ok?.removeFromSuperview()
        self.time?.removeFromSuperview()
        self.okTextField.removeFromSuperview()
        self.timeTextField.removeFromSuperview()
        self.removeFromSuperlayer()
    }
    
    func disable_resize() {
        self.viewsHidden = true
        self.circle?.isHidden = true
        self.delete?.isHidden = true
        self.expand?.isHidden = true
        self.ok?.isHidden = true
        self.time?.isHidden = true
    }
    
    func enable_resize() {
        self.viewsHidden = false
        self.circle?.isHidden = false
        self.delete?.isHidden = false
        self.expand?.isHidden = false
        self.ok?.isHidden = false
        self.time?.isHidden = false
    }
    
    
    
    static func getArrowpoints(inSide: sides.RawValue, outSide: sides.RawValue, from circle1: CircleView, to circle2: CircleView) -> [CGPoint] {
        print(inSide, outSide, circle1.myLayer?.isHorizontal, circle2.myLayer?.isHorizontal)
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        
        let start = circle1.mainPoint!
        let end = circle2.mainPoint!
        var _start: CGPoint!
        var _end: CGPoint!
        var points1 = [CGPoint]()
        var points2 = [CGPoint]()
        
        points1.append(start)
        points2.append(end)
        switch inSide {
        case sides.left.rawValue:
            _start = CGPoint(x: start.x - 40, y: start.y)
            break
        case sides.right.rawValue:
            _start = CGPoint(x: start.x + 40, y: start.y)
            break
        case sides.top.rawValue:
            _start = CGPoint(x: start.x, y: start.y - 40)
            break
        case sides.bottom.rawValue:
            _start = CGPoint(x: start.x, y: start.y + 40)
            break
        default:
            print("in default")
            if circle1.myLayer?.isHorizontal == true{
                if start.y > end.y{
                    _start = CGPoint(x: start.x, y: start.y - 40)
                }
                else{
                    _start = CGPoint(x: start.x, y: start.y + 40)
                }
            }
            else{
                if start.x > end.x{
                    _start = CGPoint(x: start.x - 40, y: start.y)
                }
                else{
                    _start = CGPoint(x: start.x + 40, y: start.y)
                }
            }
            break
            
        }
        
        switch outSide {
        case sides.left.rawValue:
            _end = CGPoint(x: end.x - 40, y: end.y)
            break
        case sides.right.rawValue:
            _end = CGPoint(x: end.x + 40, y: end.y)
            break
        case sides.top.rawValue:
            _end = CGPoint(x: end.x, y: end.y - 40)
            break
        case sides.bottom.rawValue:
            _end = CGPoint(x: end.x, y: end.y + 40)
            break
        default:
            print("out default")
            if circle2.myLayer?.isHorizontal == true{
                if start.y > end.y{
                    _end = CGPoint(x: end.x, y: end.y + 40)
                }
                else{
                    _end = CGPoint(x: end.x, y: end.y - 40)
                }
            }
            else{
                if start.x > end.x{
                    _end = CGPoint(x: end.x + 40, y: end.y)
                }
                else{
                    _end = CGPoint(x: end.x - 40, y: end.y)
                }
            }
            break
        }
        let dx = _start.x - _end.x
        let dy = _start.y - _end.y
        
        points1.append(_start)
        points2.append(_end)
        
        //Bottom Right Quadrant
        if dx <= 0, dy <= 0{
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                if _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                    
                    
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x ,(_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) )])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            
        }
            
            //Top Right Quadrant
        else if dx <= 0, dy >= 0 {
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .towardZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                if _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                    
                    
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 50 , (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y) ])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y ), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
        }
            
            
            //Top Left Quadrant
        else if dx >= 0, dy >= 0{
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                if _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x ,(_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) )])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .towardZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
        }
            
            //Bottom Left Quadrant
        else if dx >= 0, dy <= 0{
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y ), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                if _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                    
                    
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 50 , (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y) ])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
        }
        points1.append(contentsOf: points2.reversed())
        return points1
    }
    
}
