//
//  HomeViewController.swift
//  Main
//
//  Created by Gaurav Pai on 17/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

var data = helperDatabase()

class HomeViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    // MARK: - Properties
    
    static var delegate: HomeControllerDelegate?
    
    //slider variables
    private var sliderUpOffset: CGFloat!
    private var sliderUp: CGPoint!
    private var sliderDown: CGPoint!
    private var sliderCenter: CGPoint!
    private var slideView : UIView!
    private let height = UIScreen.main.bounds.height
    private let width = UIScreen.main.bounds.width
    private var isTimeSet = false
    private var countdownValue: Double?
    
    //drop variables
    private let shapes = ["rectangle", "triangle", "circle", "rhombus"]
    private var dropZone: UIView!
    {
        didSet
        {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    // MARK: - Integration Properties
    
    var scrollView: UIScrollView?
    //    var dropZone: UIView?
    var gridView: GridView!
    //variables that falicitate drawing arrows between two pluses(circle view with plus image inside)
    var firstCircle : CircleView? = nil
    var secondCircle : CircleView? = nil
    var jsonData : Data?
    static var uniqueProcessID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureNavigationBar()
        configureSlider()
        self.scrollView?.delegate = self
        
        // Do any additional setup after loading the view
    }
    
    // MARK: - Handlers
    
    // To add the left bar button to bring up the Menu
    func configureNavigationBar()
    {
        
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationItem.title = "Excelsior"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "options")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didClickMenu))
    }
    
    // Creates a drop zone which spans the enitre screen so that drop can be performed anywhere
    func createDropZone()
    {
        dropZone = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 3, height: self.view.frame.height * 3))
        scrollView!.addSubview(dropZone)
        dropZone.backgroundColor = .white
    }
    
    //Creating the slider and applying Pan gesture to it
    func configureSlider(){
        let slideViewController = SlideViewController()
        addChild(slideViewController)
        slideViewController.didMove(toParent: self)
        slideViewController.view.frame = CGRect(x: 0, y: height - 55, width: width, height: height/3)
        //slideViewController.view.backgroundColor = UIColor.lightGray
        view.addSubview(slideViewController.view)
        slideView = slideViewController.view
        
        //Creating the panGesture for slider
        sliderUpOffset = height/3
        sliderUp = CGPoint(x: slideView.center.x, y: slideView.center.y - height/3 + 55)
        sliderDown = slideView.center
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        slideView.isUserInteractionEnabled = true
        slideView.addGestureRecognizer(panGestureRecognizer)
    }
    
    //Configure the scroll view
    func configureScrollView()
    {
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollView!)
        self.scrollView!.backgroundColor = UIColor.blue
        
        self.scrollView?.delegate = self
        
        self.scrollView!.contentSize = CGSize(width: self.view.frame.width.rounded(to: 50) * 3, height: self.view.frame.height.rounded(to: 50) * 3)
        self.dropZone = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width.rounded(to: 50) * 3, height: self.view.frame.height.rounded(to: 50) * 3))
        self.scrollView!.addSubview(dropZone!)
        self.dropZone!.backgroundColor = UIColor.white
        self.scrollView?.canCancelContentTouches = false
        //set appropriate zoom scale for the scroll view
        self.scrollView!.maximumZoomScale = 6.0
        self.scrollView!.minimumZoomScale = 0.5
        self.scrollView!.setZoomScale(1.0, animated: true)
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        
        let screenshotButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: 60, width: 100, height: 40))
        screenshotButton.setTitle("Screenshot", for: UIControl.State.normal)
        screenshotButton.backgroundColor = UIColor.black
        
        self.view.addSubview(screenshotButton)
        let screenshotGesture = UITapGestureRecognizer(target: self, action: #selector(take_screenshot))
        screenshotGesture.numberOfTapsRequired = 1
        screenshotGesture.delegate = self
        screenshotButton.addGestureRecognizer(screenshotGesture)
        
        
        let saveButton = UIButton(frame: CGRect(x: self.view.frame.width - 210, y: 60, width: 100, height: 40))
        saveButton.setTitle("Save", for: UIControl.State.normal)
        saveButton.backgroundColor = UIColor.black
        
        self.view.addSubview(saveButton)
        let saveGesture = UITapGestureRecognizer(target: self, action: #selector(save_action))
        saveGesture.numberOfTapsRequired = 1
        saveGesture.delegate = self
        saveButton.addGestureRecognizer(saveGesture)
        
        
        let loadButton = UIButton(frame: CGRect(x: self.view.frame.width - 320, y: 60, width: 100, height: 40))
        loadButton.setTitle("Load", for: UIControl.State.normal)
        loadButton.backgroundColor = UIColor.black
        
        self.view.addSubview(loadButton)
        let loadGesture = UITapGestureRecognizer(target: self, action: #selector(load_action))
        loadGesture.numberOfTapsRequired = 1
        loadGesture.delegate = self
        loadButton.addGestureRecognizer(loadGesture)
        
        
        let bottleneckButton = UIButton(frame: CGRect(x: self.view.frame.width - 430, y: 60, width: 100, height: 40))
        bottleneckButton.setTitle("Bottleneck", for: UIControl.State.normal)
        bottleneckButton.backgroundColor = UIColor.black
        
        self.view.addSubview(bottleneckButton)
        let bottleneckGesture = UITapGestureRecognizer(target: self, action: #selector(bottleneck_action))
        bottleneckGesture.numberOfTapsRequired = 1
        bottleneckGesture.delegate = self
        bottleneckButton.addGestureRecognizer(bottleneckGesture)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //tap gesture for anything other than demoviews
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = self
        dropZone!.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        dropZone!.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        
        
        
        
        gridView = GridView(frame : dropZone!.frame)
        gridView.backgroundColor = UIColor.clear
        gridView.isUserInteractionEnabled = false
        
        
        dropZone!.addSubview(gridView)
        
    }
    
    
    //     Handling Drop
    //    1. Type of Object the drop zone can accept
    //    2. Type of drop proposal (copy, move, forbidden, cancel)
    //    3. What to do when drop is performed. Call custom methods for each drop objects
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: UIImage.self) { images in
            for image in images {
                let dropPoint = session.location(in: self.dropZone)
                print(dropPoint)
                let img = image as? UIImage
                var shapeName : String = ""
                if (img?.isEqual(to: UIImage(named: "rectangle")!))!
                {
                    shapeName = "rectangle"
                }
                else if (img?.isEqual(to: UIImage(named: "rhombus")!))!
                {
                    shapeName = "rhombus"
                }
                else if (img?.isEqual(to: UIImage(named: "harddisk")!))!
                {
                    shapeName = "harddisk"
                }
                else if (img?.isEqual(to: UIImage(named: "database")!))!
                {
                    shapeName = "database"
                }
                else if (img?.isEqual(to: UIImage(named: "rounded rectangle")!))!
                {
                    shapeName = "rounded rectangle"
                }
                self.add_a_shape(shape: shapeName, x: dropPoint.x - 75, y: dropPoint.y - 75, width: 150, height: 150, withID:self.getUniqueID(), withText: "Insert Text", withCircleID: [self.getUniqueID(),self.getUniqueID(),self.getUniqueID(),self.getUniqueID()] )
                
            }
        }
    }
    
    //    Generates unique ID for the shapes
    func getUniqueID() -> Int{
        HomeViewController.uniqueProcessID += 1
        return HomeViewController.uniqueProcessID
    }
    
    //  Function to create a shape. Pass shapeName, position, width and height, unique Id and text to be entered in the middle
    
    func add_a_shape(shape: String , x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, withID id: Int, withText text: String, withCircleID IDs: [Int]){
        //choose frame size
        let demoView = processView(frame: CGRect(x: x,
                                                 y: y,
                                                 width: width,
                                                 height: height), ofShape: shape, withID: id, withText: text)
        data.views.append(demoView) // keep track
        
        
        demoView.isUserInteractionEnabled = true
        
        dropZone!.addSubview(demoView)
        
        //create the pluses around the view. need to do it here inorder to add it to its superview. which will only be assigned after addSubview above
        
        demoView.createCircles(IDs[0],IDs[1],IDs[2],IDs[3] )
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(circlegesture))
        
        //add gesture to all the pluses
        for circle in demoView.circles{
            circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circlegesture)))
        }
        demoView.delete?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletegesture)))
        
        demoView.btlneckBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottleneckgesture)))
        
        data.viewsAndData[demoView] = uiViewData(x: Double(x), y: Double(y), width: Double(width), height: Double(height), shape: shape, text: demoView.textView.text, id: id, leftID: IDs[0], topID: IDs[1], rightID: IDs[2], bottomID: IDs[3])
        data.idAndAny[id] = demoView
        //        allData.allViews.append(uiViewData(x: Double(x), y: Double(y), width: Double(width), height: Double(height), shape: shape, leftLine: lineData(id: 0, isSrc: false), rightLine: lineData(id: 0, isSrc: false), topLine: lineData(id: 0, isSrc: false), bottomLine: lineData(id: 0, isSrc: false), text: demoView.textView.text))
        
    }
    
    
    func disable_all() {
        for view in data.views {
            view.disable_resize()
        }
        print("number of arrows = \(data.arrows.count)")
        for arrow in data.arrows{
            arrow.disable_resize()
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("zooming in")
        return self.dropZone!
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Prevent subviews of a specific view to send touch events to the view's gesture recognizers.
        if let touchedView = touch.view, let gestureView = gestureRecognizer.view, touchedView.isDescendant(of: gestureView), touchedView !== gestureView {
            return false
        }
        return true
    }
    
    
    // MARK:- Gesture Handlers
    @objc func didPan(sender: UIPanGestureRecognizer)
    {
        
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began
        {
            sliderCenter = slideView.center
            print("Gesture began")
            
        }
        else if sender.state == .changed
        {
            slideView.center = CGPoint(x: sliderCenter.x, y: sliderCenter.y + translation.y)
            print("Gesture is changing")
        }
        else if sender.state == .ended
        {
            if velocity.y > 0
            {
                UIView.animate(withDuration: 0.8, animations: { () -> Void in self.slideView.center = self.sliderDown})
            }
            else
            {
                UIView.animate(withDuration: 0.8, animations: {() -> Void in self.slideView.center = self.sliderUp })
            }
            print("Gesture ended")
        }
        
    }
    
    @objc func didClickMenu()
    {
        print("Registered click")
        HomeViewController.delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    
    // MARK:- Integration Gesture Handlers
    @objc func circlegesture(_ sender: UITapGestureRecognizer){
        print("print circle")
        if firstCircle == nil {
            firstCircle = sender.view as! CircleView?
            firstCircle?.hasConnection = true
            //            firstCircle?.isHidden = true
        }else{
            //            draw_line(point1: (firstCircle?.center)!, point2: (sender.view?.center)!)
            secondCircle = sender.view as! CircleView?
            let arrowShape = (firstCircle?.lineTo(circle: secondCircle!))!
            arrowShape.arrowID = getUniqueID()
            arrowShape.setSubView(self.dropZone!)
            arrowShape.createCircles(getUniqueID())
            arrowShape.circle?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circlegesture)))
            arrowShape.delete?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletegesture)))
            
            data.arrows.append(arrowShape)
            data.idAndAny[arrowShape.arrowID!] = arrowShape
            data.arrowsAndData[arrowShape] = arrowData(id: arrowShape.arrowID!, circleID: (arrowShape.circle?.circleID)!, srcID: (firstCircle?.circleID)!, dstID: (secondCircle?.circleID)!, isExpanded: false, okText: "", timeText: "" )
            dropZone!.layer.addSublayer(arrowShape)
            //            addLineData(from: firstCircle!, to: secondCircle!)
            secondCircle?.hasConnection = true
            //            secondCircle?.isHidden = true
            firstCircle = nil
            secondCircle = nil
        }
    }
    
    @objc func deletegesture(_ sender: UITapGestureRecognizer){
        
        print("print delete")
        let del = sender.view as! CircleView?
        if del?.myView != nil{
            for circle in (del?.myView?.circles)!{
                //            circle.inComingLine
                //            circle.outGoingLine
                circle.removeFromSuperview()
                
            }
            data.views.removeObjFromArray(object: del?.myView)
            let Viewdata = data.viewsAndData[(del?.myView)!]
            //            idAndView.removeValue(forKey: Viewdata!.id)
            data.idAndAny.removeValue(forKey: (Viewdata?.id)!)
            data.viewsAndData.removeValue(forKey: (del?.myView)!)
            
            del?.myView?.removeFromSuperview()
            del?.removeFromSuperview()
        }
        if del?.myLayer != nil{
            data.arrows.removeObjFromArray(object: del?.myLayer)
            let Arrowdata = data.arrowsAndData[(del?.myLayer)!]
            data.idAndAny.removeValue(forKey: (Arrowdata?.id)!)
            data.arrowsAndData.removeValue(forKey: (del?.myLayer)!)
            
            del?.myLayer?.inputCircle.hasConnection = false
            del?.myLayer?.outputCircle.hasConnection = false
            del?.myLayer?.removeEverything()
        }
        
        
    }
    
    
    @objc func bottleneckgesture(_ sender: UITapGestureRecognizer){
        if isTimeSet == false {
            let vc = setTimeViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc,animated:true)
        }
        else{
            let vc = recordBottleneckViewController()
            let view = sender.view as? CircleView
            vc.inputProcessView = view?.myView
//            vc.seconds = Int(self.countdownValue!)
            vc.seconds = 5
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    //gesture to recognize tap in dropZone which contains all the diagrams
    @objc func singleTap(_ sender: UITapGestureRecognizer) {
        if firstCircle == nil{
            disable_all()
        }
        
        firstCircle?.hasConnection = false
        firstCircle?.isHidden = false
        firstCircle = nil
        print("touches in viewcontroller")
        UIView.animate(withDuration: 0.2, animations: { () -> Void in self.slideView.center = self.sliderDown})
        
    }
    
    @objc func doubleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation:CGPoint = sender.location(in: dropZone)
        if let sublayers = dropZone!.layer.sublayers {
            for layer in sublayers {
                if let temp = layer as? ArrowShape{
                    if (temp.path?.contains(tapLocation))!{
                        print("touched arrow")
                        //temp.updateViews(withPoint: tapLocation)
                        if temp.viewsHidden{
                            temp.enable_resize()
                        }
                        else{
                            temp.disable_resize()
                        }
                    }
                }
            }
        }
    }
    
    @objc func bottleneck_action(_ sender: UITapGestureRecognizer) {
        let vc = BottleneckViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func take_screenshot(_ sender: UITapGestureRecognizer) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let imgPath = dropZone!.exportAsPdfFromView()
        print("\(imgPath)")
    }
    
    
    @objc func save_action(_ sender: UITapGestureRecognizer) {
        
        let jsonEncoder = JSONEncoder()
        //jsonEncoder.outputFormatting = .prettyPrinted
        //        allData.allViews.removeAll()
        let allData = entireData()
        
        for view in data.views{
            data.viewsAndData[view]?.text = view.textView.text
            data.viewsAndData[view]?.x = Double(view.frame.origin.x)
            data.viewsAndData[view]?.y = Double(view.frame.origin.y)
            data.viewsAndData[view]?.width = Double(view.frame.width)
            data.viewsAndData[view]?.height = Double(view.frame.height)
            allData.allViews.append(data.viewsAndData[view]!)
        }
        
        for arrow in data.arrows{
            data.arrowsAndData[arrow]?.okText = arrow.okTextField.text ?? ""
            data.arrowsAndData[arrow]?.timeText = arrow.timeTextField.text ?? ""
            data.arrowsAndData[arrow]?.isExpanded = arrow.isExpanded
            allData.allArrows.append(data.arrowsAndData[arrow]!)
        }
        self.jsonData = try? jsonEncoder.encode(allData)
        
        print(String(data: jsonData!, encoding: .utf8)!)
        
    }
    
    @objc func load_action(_ sender: UITapGestureRecognizer) {
        let jsonDecoder = JSONDecoder()
        let decodedData = try? jsonDecoder.decode(entireData.self, from: self.jsonData!)
        if decodedData != nil {
            let allData = decodedData
            print(allData?.allArrows.count)
            print(allData?.allViews.count)
            restoreState(allData: allData!)
        }
    }
    
    func restoreState(allData: entireData){
        data.reset()
        for view in (dropZone?.subviews)!{
            view.removeFromSuperview()
        }
        dropZone!.layer.sublayers = nil
        dropZone?.addSubview(gridView)
        
        for viewData in allData.allViews{
            add_a_shape(shape: viewData.shape, x: CGFloat(viewData.x), y: CGFloat(viewData.y
            ), width: CGFloat(viewData.width), height: CGFloat(viewData.height), withID:  viewData.id, withText: viewData.text, withCircleID: [viewData.leftID,viewData.topID,viewData.rightID,viewData.bottomID])
        }
        disable_all()
        
        
        for lineData in allData.allArrows{
            let srcCircle = getCircleFromID(id: lineData.srcID)
            let dstCircle = getCircleFromID(id: lineData.dstID)
            
            if srcCircle != nil, dstCircle != nil{
                let arrowShape = (srcCircle?.lineTo(circle: dstCircle!))!
                arrowShape.arrowID = lineData.id
                arrowShape.setSubView(self.dropZone!)
                arrowShape.createCircles(lineData.circleID)
                arrowShape.circle?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circlegesture)))
                arrowShape.delete?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletegesture)))
                arrowShape.isExpanded = lineData.isExpanded
                data.arrows.append(arrowShape)
                data.idAndAny[arrowShape.arrowID!] = arrowShape
                data.arrowsAndData[arrowShape] = arrowData(id: arrowShape.arrowID!, circleID: (arrowShape.circle?.circleID)!, srcID: (srcCircle?.circleID)!, dstID: (dstCircle?.circleID)!, isExpanded: lineData.isExpanded, okText: lineData.okText, timeText: lineData.timeText )
                dropZone!.layer.addSublayer(arrowShape)
            }
        }
    }
    
    func getCircleFromID(id: Int) -> CircleView?{
        for view in data.views{
            for circle in view.circles{
                if circle.circleID == id{
                    return circle
                }
            }
        }
        
        for arrow in data.arrows{
            if arrow.circle?.circleID == id{
                return arrow.circle!
            }
        }
        return nil
    }
}

extension UIImage {
    func isEqual(to image: UIImage) -> Bool {
        guard let data1: Data = self.pngData(),
            let data2: Data = image.pngData() else {
                return false
        }
        return data1.elementsEqual(data2)
    }
}

extension FloatingPoint {
    func rounded(to value: Self, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self{
        return (self / value).rounded(roundingRule) * value
        
    }
}

extension CGPoint {
    func rounded(to value: CGFloat, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGPoint{
        return CGPoint(x: CGFloat((self.x / value).rounded(.toNearestOrAwayFromZero) * value), y: CGFloat((self.y / value).rounded(.toNearestOrAwayFromZero) * value))
    }
}

extension CGRect {
    func rounded(to value: CGFloat, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGRect{
        return CGRect(x: self.origin.x, y: self.origin.y, width: CGFloat((self.width / value).rounded(.toNearestOrAwayFromZero) * value), height: CGFloat((self.height / value).rounded(.toNearestOrAwayFromZero) * value))
    }
}


extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension HomeViewController: setTimeControllerDelegate
{
    
    func setCountdown(with value: Double)
    {
        self.isTimeSet = true
        self.countdownValue = value
        print("time in home is \(self.countdownValue)")
    }
}
