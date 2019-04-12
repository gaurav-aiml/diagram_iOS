//
//  HomeViewController.swift
//  Main
//
//  Created by Gaurav Pai on 17/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

var data = helperDatabase()

class HomeViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, AppFileManipulation, AppFileStatusChecking, AppFileSystemMetaData {
    
    
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
    var dummyView: UIView!
    //variables that falicitate drawing arrows between two pluses(circle view with plus image inside)
    var firstCircle : CircleView? = nil
    var secondCircle : CircleView? = nil
    var jsonData : Data?
    var oldjSONData : Data?
    static var uniqueProcessID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureNavigationBar()
        configureSlider()
        self.scrollView?.delegate = self
        ContainerViewController.menuDelegate = self
        // Do any additional setup after loading the view
        load_action()
    }
    
    // MARK: - Handlers
    
    // To add the left bar button to bring up the Menu
    func configureNavigationBar()
    {
        
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationItem.title = "Excelsior"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "options")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didClickMenu))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "exit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didClickExit))
    }
    
//    // Creates a drop zone which spans the enitre screen so that drop can be performed anywhere
//    func createDropZone()
//    {
//        dropZone = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 3, height: self.view.frame.height * 3))
//        scrollView!.addSubview(dropZone)
//        dropZone.backgroundColor = .white
//    }
    
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
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollView!)
        self.scrollView!.backgroundColor = UIColor.gray
        
        self.scrollView?.delegate = self
        
        self.scrollView!.contentSize = CGSize(width: self.view.frame.width.rounded(to: 50), height: self.view.frame.height.rounded(to: 50))
        self.dropZone = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width.rounded(to: 50), height: self.view.frame.height.rounded(to: 50)))
        
        self.dummyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width.rounded(to: 50), height: self.view.frame.height.rounded(to: 50)))
        self.scrollView!.addSubview(dropZone!)
        self.dummyView.backgroundColor = .clear
        //self.dummyView.addSubview(dropZone)
        self.dropZone!.backgroundColor = UIColor.white
        self.scrollView?.canCancelContentTouches = false
        //set appropriate zoom scale for the scroll view
        self.scrollView!.maximumZoomScale = 6.0
        self.scrollView!.minimumZoomScale = 0.5
        self.scrollView!.setZoomScale(1.0, animated: true)
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
//        setZoomScale()
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

    func setZoomScale() {
        let imageViewSize = dropZone.bounds.size
        let scrollViewSize = scrollView!.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        scrollView!.minimumZoomScale = max(widthScale, heightScale)
        //scrollView.zoomScale = 1.0
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
    
    func checkForChanges()
    {
        let jsonEncoder = JSONEncoder()
        let allData = entireData()
        for view in data.views
        {
            data.viewsAndData[view]?.text = view.textView.text
            data.viewsAndData[view]?.x = Double(view.frame.origin.x)
            data.viewsAndData[view]?.y = Double(view.frame.origin.y)
            data.viewsAndData[view]?.width = Double(view.frame.width)
            data.viewsAndData[view]?.height = Double(view.frame.height)
            allData.allViews.append(data.viewsAndData[view]!)
        }
        for arrow in data.arrows
        {
            data.arrowsAndData[arrow]?.okText = arrow.okTextField.text ?? ""
            data.arrowsAndData[arrow]?.timeText = arrow.timeTextField.text ?? ""
            data.arrowsAndData[arrow]?.isExpanded = arrow.isExpanded
            allData.allArrows.append(data.arrowsAndData[arrow]!)
        }
        self.jsonData = try? jsonEncoder.encode(allData)
        
        
        let fileName = "/"+LandingPageViewController.projectName+"/"+LandingPageViewController.projectName+".excelsior"
        let file = FileHandling(name: fileName)
        
        if file.findFile()
        {
            try? self.oldjSONData = Data(contentsOf: getURL(for: .Documents).appendingPathComponent(fileName), options: .uncachedRead)
            print("Old Data restored")
        }
    }
    
    func load_action()
    {
        let fileName = "/"+LandingPageViewController.projectName+"/"+LandingPageViewController.projectName+".excelsior"
        let file = FileHandling(name: fileName)
        if file.findFile() {
            try? self.jsonData = Data(contentsOf: getURL(for: .Documents).appendingPathComponent(fileName), options: .uncachedRead)
            print("Data encoded")
            let jsonDecoder = JSONDecoder()
            let decodedData = try? jsonDecoder.decode(entireData.self, from: self.jsonData!)
            if decodedData != nil {
                let allData = decodedData

                restoreState(allData: allData!)
            }
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
        demoView.resizeDelegate = self
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
        
        resizeDropZone()
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
    
    @objc func didClickExit(){
        
        checkForChanges()
        
        if String(data: self.jsonData!, encoding: .utf8) == String(data: self.oldjSONData!, encoding: .utf8)
        {
            dismiss(animated: true)
        }
            
        else
        {
            let alert = UIAlertController(title: "Exiting without saving changes!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                ContainerViewController.menuDelegate?.saveViewState()
                self.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                self.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
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
            del?.myView?.btlneckBtn.removeFromSuperview()
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
            self.showToast(message: "Set Debottling Timer First in the menu")
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
    
    // End of Class HomeViewController
}


// Extenstions

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
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x:0, y: 0, width: 150, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = "  "+message+"  "
        toastLabel.sizeToFit()
        toastLabel.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-75)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

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

extension HomeViewController: resizeDropzoneDelegate
{
    func resizeDropZone() {
        print("Resize called")

        var maxX : CGFloat = self.view.frame.width
        var maxY : CGFloat = self.view.frame.height
        for view in data.views{
            maxX = maxX < view.center.x ? view.center.x : maxX
            maxY = maxY < view.center.y ? view.center.y : maxY
        }
        
        maxX = (maxX + 500).rounded(to: 50)
        maxY = (maxY + 500).rounded(to: 50)

        let zoom = scrollView!.zoomScale

        self.scrollView!.contentSize = CGSize(width: maxX*zoom, height: maxY*zoom)

        
        //self.dummyView.frame = CGRect(x: 0, y: 0, width: maxX*zoom, height: maxY*zoom)
        self.dropZone.frame =  CGRect(x: 0, y: 0, width: maxX*zoom, height: maxY*zoom)


        gridView.removeFromSuperview()
        gridView = GridView(frame : CGRect(x: 0, y: 0, width: maxX, height: maxY))
        gridView.backgroundColor = UIColor.clear
        gridView.isUserInteractionEnabled = false
        dropZone!.addSubview(gridView)
        dropZone.sendSubviewToBack(gridView)

    }
}


extension HomeViewController: menuControllerDelegate
{
    
    func saveViewState() {
        
        let jsonEncoder = JSONEncoder()
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
        
        let path = getURL(for: .Documents).appendingPathComponent(LandingPageViewController.projectName)
        let fileName = LandingPageViewController.projectName+".excelsior"
        if writeFile(containing: String(data: jsonData!, encoding: .utf8)!, to: path, withName: fileName) {
            self.showToast(message: "Saved Successfully.")
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func saveViewStateAsNew() {
        
        let jsonEncoder = JSONEncoder()
        let allData = entireData()
        
        for view in data.views
        {
            data.viewsAndData[view]?.text = view.textView.text
            data.viewsAndData[view]?.x = Double(view.frame.origin.x)
            data.viewsAndData[view]?.y = Double(view.frame.origin.y)
            data.viewsAndData[view]?.width = Double(view.frame.width)
            data.viewsAndData[view]?.height = Double(view.frame.height)
            allData.allViews.append(data.viewsAndData[view]!)
        }
        
        for arrow in data.arrows
        {
            data.arrowsAndData[arrow]?.okText = arrow.okTextField.text ?? ""
            data.arrowsAndData[arrow]?.timeText = arrow.timeTextField.text ?? ""
            data.arrowsAndData[arrow]?.isExpanded = arrow.isExpanded
            allData.allArrows.append(data.arrowsAndData[arrow]!)
        }
        self.jsonData = try? jsonEncoder.encode(allData)
        
        
        
        let alert = UIAlertController(title: "Enter the name of the Project", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "The name should be unique"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if ((alert.textFields?.first?.text) != nil)
            {
                LandingPageViewController.projectName = alert.textFields!.first!.text!
                let directory = FileHandling(name: LandingPageViewController.projectName)
                if directory.createNewProjectDirectory()
                {
                    print("Directory successfully created!")
                    let path = self.getURL(for: .Documents).appendingPathComponent(LandingPageViewController.projectName)
                    let fileName = LandingPageViewController.projectName+".excelsior"
                    if self.writeFile(containing: String(data: self.jsonData!, encoding: .utf8)!, to: path, withName: fileName)
                    {
                        self.showToast(message: "Saved Successfully")
                    }
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    func takeScreenShot()
    {
        self.gridView.isHidden = true
        self.dropZone.exportAsImage()
        
        self.showToast(message: "Screenshot captured!")
        self.gridView.isHidden = false
    }
    
    func exportAsPDF()
    {
        self.gridView.isHidden = true
        let imgPath = dropZone!.exportAsPdfFromView(name: LandingPageViewController.projectName)
        print("\(imgPath)")
        self.showToast(message: "PDF created successfully")
        self.gridView.isHidden = false
    }
    
    func startDebottling(){
        let vc = BottleneckViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTimerForDebottling(){
        let popoverVC = setTimeViewController()
        popoverVC.delegate = self
        
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 300, height: 300)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.height/2)
            popoverController.permittedArrowDirections = .any
            //popoverController.delegate = self
            //popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
//            self.navigationController?.pushViewController(popoverVC,animated:true)

    }
}





extension HomeViewController: setTimeControllerDelegate
{
    
    func setCountdown(with value: Double)
    {
        self.isTimeSet = true
        self.countdownValue = value
        self.showToast(message: "Timer value set to \(String(describing: value)) seconds")
    }
}
