//
//  HomeViewController.swift
//  Main
//
//  Created by Gaurav Pai on 17/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

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
    
    var allData = entireData()
    var scrollView: UIScrollView!
    
    //keep track of all views that contain a diagram(BezierPath)
    var views = [processView]()
    
    //Rename as a dict
    var viewsAndData = [processView: uiViewData]()
    var idAndView = [Int: processView]()
    
    //variables that falicitate drawing arrows between two pluses(circle view with plus image inside)
    var firstCircle : CircleView? = nil
    var secondCircle : CircleView? = nil
    
    // saving and loading variables
    var jsonData : Data?
    static var uniqueProcessID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureNavigationBar()
        configureSlider()
        self.scrollView?.delegate = self
        
        
        
//        let screenshotButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: 30, width: 100, height: 70))
//        screenshotButton.setTitle("Screenshot", for: UIControl.State.normal)
//        screenshotButton.backgroundColor = UIColor.black
//        self.view.addSubview(screenshotButton)
//        let screenshotGesture = UITapGestureRecognizer(target: self, action: #selector(take_screenshot))
//        screenshotGesture.numberOfTapsRequired = 1
//        screenshotGesture.delegate = self
//        //screenshotButton.addGestureRecognizer(screenshotGesture)
//
//
//        let saveButton = UIButton(frame: CGRect(x: self.view.frame.width - 210, y: 30, width: 100, height: 70))
//        saveButton.setTitle("Save", for: UIControl.State.normal)
//        saveButton.backgroundColor = UIColor.black
//
//        self.view.addSubview(saveButton)
//        let saveGesture = UITapGestureRecognizer(target: self, action: #selector(save_action))
//        saveGesture.numberOfTapsRequired = 1
//        saveGesture.delegate = self
//        saveButton.addGestureRecognizer(saveGesture)
//
//
//        let loadButton = UIButton(frame: CGRect(x: self.view.frame.width - 320, y: 30, width: 100, height: 70))
//        loadButton.setTitle("Load", for: UIControl.State.normal)
//        loadButton.backgroundColor = UIColor.black
//
//        self.view.addSubview(loadButton)
//        let loadGesture = UITapGestureRecognizer(target: self, action: #selector(load_action))
//        loadGesture.numberOfTapsRequired = 1
//        loadGesture.delegate = self
//        loadButton.addGestureRecognizer(loadGesture)
//
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //tap gesture for anything other than demoviews
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        mytapGestureRecognizer.delegate = self
        dropZone.addGestureRecognizer(mytapGestureRecognizer)
        

        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "exit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(exitToLandingPage) )
        
    }
    
    // Creates a drop zone which spans the enitre screen so that drop can be performed anywhere
    func createDropZone()
    {
        dropZone = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 3, height: self.view.frame.height * 3))
        scrollView.addSubview(dropZone)
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
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(scrollView!)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height * 3)
        self.createDropZone()
        scrollView.canCancelContentTouches = false
        
        //set appropriate zoom scale for the scroll view
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.25
        scrollView.setZoomScale(1.0, animated: true)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
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
                self.add_a_shape(shape: shapeName, x: dropPoint.x, y: dropPoint.y, width: 160, height: 160, withID:self.getUniqueID(), withText: "Insert Your Text Here" )
            }
        }
    }
    
//    Generates unique ID for the shapes
    func getUniqueID() -> Int{
        HomeViewController.uniqueProcessID += 1
        return HomeViewController.uniqueProcessID
    }
    
//  Function to create a shape. Pass shapeName, position, width and height, unique Id and text to be entered in the middle
    func add_a_shape(shape: String , x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, withID id: Int, withText text: String){
        //choose frame size
        let demoView = processView(frame: CGRect(x: x,
                                                 y: y,
                                                 width: width,
                                                 height: height), ofShape: shape, withID: id, withText: text)
        views.append(demoView) // keep track
        
        
        demoView.isUserInteractionEnabled = true
        dropZone!.addSubview(demoView)
        
        //create the pluses around the view. need to do it here inorder to add it to its superview. which will only be assigned after addSubview above
        demoView.createCircles()
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(circlegesture))
        
        //add gesture to all the pluses
        for circle in demoView.circles{
            circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circlegesture)))
        }
        demoView.delete?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletegesture)))
        
        
        
        viewsAndData[demoView] = uiViewData(x: Double(x), y: Double(y), width: Double(width), height: Double(height), shape: shape, leftLine: lineData(id: 0, isSrc: false), rightLine: lineData(id: 0, isSrc: false), topLine: lineData(id: 0, isSrc: false), bottomLine: lineData(id: 0, isSrc: false), text: demoView.textView.text, id: id)
        idAndView[id] = demoView
        
        //        allData.allViews.append(uiViewData(x: Double(x), y: Double(y), width: Double(width), height: Double(height), shape: shape, leftLine: lineData(id: 0, isSrc: false), rightLine: lineData(id: 0, isSrc: false), topLine: lineData(id: 0, isSrc: false), bottomLine: lineData(id: 0, isSrc: false), text: demoView.textView.text))
        
    }
    
    func addLineData(from input: CircleView, to output: CircleView){
        let ID = CircleView.getUniqueID()
        switch input.side {
        case sides.left.rawValue :
            viewsAndData[input.myView!]?.leftLine.id = ID
            viewsAndData[input.myView!]?.leftLine.isSrc = true
            break
        case sides.top.rawValue :
            viewsAndData[input.myView!]?.topLine.id = ID
            viewsAndData[input.myView!]?.topLine.isSrc = true
            break
        case sides.right.rawValue:
            viewsAndData[input.myView!]?.rightLine.id = ID
            viewsAndData[input.myView!]?.rightLine.isSrc = true
            break
        case sides.bottom.rawValue:
            viewsAndData[input.myView!]?.bottomLine.id = ID
            viewsAndData[input.myView!]?.bottomLine.isSrc = true
            break
        case .none:
            break
        case .some(_):
            break
        }
        
        switch output.side {
        case sides.left.rawValue :
            viewsAndData[output.myView!]?.leftLine.id = ID
            viewsAndData[output.myView!]?.leftLine.isSrc = false
            break
        case sides.top.rawValue :
            viewsAndData[output.myView!]?.topLine.id = ID
            viewsAndData[output.myView!]?.topLine.isSrc = false
            break
        case sides.right.rawValue:
            viewsAndData[output.myView!]?.rightLine.id = ID
            viewsAndData[output.myView!]?.rightLine.isSrc = false
            break
        case sides.bottom.rawValue:
            viewsAndData[output.myView!]?.bottomLine.id = ID
            viewsAndData[output.myView!]?.bottomLine.isSrc = false
            break
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    func disable_all() {
        for view in views {
            view.disable_resize()
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
        if firstCircle == nil
        {
            firstCircle = sender.view as! CircleView?
            firstCircle?.hasConnection = true
            firstCircle?.isHidden = true
        }
        else{
            //            draw_line(point1: (firstCircle?.center)!, point2: (sender.view?.center)!)
            secondCircle = sender.view as! CircleView?
            dropZone!.layer.addSublayer((firstCircle?.lineTo(circle: secondCircle!))! )
            addLineData(from: firstCircle!, to: secondCircle!)
            secondCircle?.hasConnection = true
            secondCircle?.isHidden = true
            firstCircle = nil
            secondCircle = nil
        }
    }
    
    @objc func deletegesture(_ sender: UITapGestureRecognizer){
        print("print delete")
        let del = sender.view as! CircleView?
        for circle in (del?.myView?.circles)!{
            //            circle.inComingLine
            //            circle.outGoingLine
            circle.removeFromSuperview()
        }
        del?.myView?.removeFromSuperview()
        del?.removeFromSuperview()
        
    }
    
    @objc func exitToLandingPage(){
        self.dismiss(animated: true)
    }
    
    
    //gesture to recognize tap in subView which contains all the diagrams
    @objc func myTapAction(_ sender: UITapGestureRecognizer)
    {
        if sender.view is CircleView {
            print("touched a circle")
        }
        else{
            
            if firstCircle == nil
            {
                // Disable resizing for all the views present
                for view in views{
                    view.disable_resize()
                }
            }
            firstCircle?.hasConnection = false
            firstCircle?.isHidden = false
            firstCircle = nil
            print("touches in viewcontroller")
            let location = sender.location(in: sender.view)
            let point = dropZone!.convert(location, from: nil)
            print("\(point)")
            let found = dropZone!.layer.hitTest(point)
            print("\(found?.name)")
            if let layer = dropZone!.layer.hitTest(point) as? CAShapeLayer {
                print("touched a shape/arrow")
            }
            
            if let sublayers = dropZone!.layer.sublayers {
                for layer in sublayers {
                    if let temp = layer as? CAShapeLayer{
                        
                        if (temp.path?.contains(point))!{
                            //    temp.removeFromSuperlayer()
                            print("arrow touched")
                        }
                    }
                }
            }
        }
        //        var touch = sender.location(in: scrollView)
        //        var done = false
        //        for view in views{
        //            if view.bounds.contains(touch){
        //                done = true
        //            }
        //        }
        //        if !done{
        //            for view in views{
        //                view.disable_resize()
        //            }
        //        }
        //        draw_line()
        
        
    }
    
    public func take_screenshot() {
    UIGraphicsBeginImageContext(self.view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    var image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    
    let imgPath = dropZone!.exportAsPdfFromView()
    print("\(imgPath)")
}
    
    public func save_action() {
    let jsonEncoder = JSONEncoder()
    //jsonEncoder.outputFormatting = .prettyPrinted
    allData.allViews.removeAll()
    
    for view in views{
        viewsAndData[view]?.text = view.textView.text
        allData.allViews.append(viewsAndData[view]!)
    }
    self.jsonData = try? jsonEncoder.encode(allData.allViews)
    
    print(String(data: jsonData!, encoding: .utf8)!)
    
}
    
    public func load_action() {
    let jsonDecoder = JSONDecoder()
    let decodedData = try? jsonDecoder.decode([uiViewData].self, from: self.jsonData!)
    allData.allViews = decodedData!
    print(allData.allViews)
    restoreState()
}
    
    func restoreState() {
        views.removeAll()
        viewsAndData.removeAll()
        for view in (dropZone?.subviews)!{
            view.removeFromSuperview()
        }
        dropZone!.layer.sublayers = nil
        
        for viewData in allData.allViews{
            add_a_shape(shape: viewData.shape, x: CGFloat(viewData.x), y: CGFloat(viewData.y
            ), width: CGFloat(viewData.width), height: CGFloat(viewData.height), withID:  viewData.id, withText: viewData.text)
        }
        disable_all()
        print(idAndView.count)
        
        
        for viewData in allData.allViews{
            var firstCircle: CircleView
            var secondCircle: CircleView
            if viewData.leftLine.id != 0, viewData.leftLine.isSrc == true{
                firstCircle = idAndView[viewData.id]!.circles[0]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.leftLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.topLine.id == viewData.leftLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.leftLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.leftLine.id, viewData2.rightLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                        
                    }
                }
            }
            if viewData.topLine.id != 0, viewData.topLine.isSrc == true{
                print("found first line point")
                firstCircle = idAndView[viewData.id]!.circles[1]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.topLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                        
                    }
                    if viewData2.topLine.id == viewData.topLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.topLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.topLine.id, viewData2.rightLine.isSrc == false{
                        print("found second line")
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                }
            }
            if viewData.bottomLine.id != 0, viewData.bottomLine.isSrc == true{
                firstCircle = idAndView[viewData.id]!.circles[2]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.bottomLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.topLine.id == viewData.bottomLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.bottomLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.bottomLine.id, viewData2.rightLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                }
            }
            if viewData.rightLine.id != 0, viewData.rightLine.isSrc == true{
                firstCircle = idAndView[viewData.id]!.circles[3]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.rightLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.topLine.id == viewData.rightLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.rightLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.rightLine.id, viewData2.rightLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        dropZone!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                }
            }
        }
        
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
