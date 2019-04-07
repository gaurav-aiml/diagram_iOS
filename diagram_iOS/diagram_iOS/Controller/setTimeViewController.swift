//
//  setTimeViewController.swift
//  Bottleneck
//
//  Created by Vishal Hosakere on 03/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class setTimeViewController: UIViewController {
    var timeSet : Double?
    private var doneBtn : UIButton!
    private var timeDial : UIDatePicker!
    var delegate: setTimeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeDial = UIDatePicker()
        timeDial.backgroundColor = .white
        timeDial.center = self.view.center
        timeDial.datePickerMode = .countDownTimer
        self.view.backgroundColor = .white
        self.view.addSubview(timeDial)
        
        doneBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        doneBtn.backgroundColor = .black
        doneBtn.setTitle("Done", for: UIControl.State.normal)
        doneBtn.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 200)
        doneBtn.addTarget(self, action: #selector(doneGesture), for: .touchUpInside)
        self.view.addSubview(doneBtn)
        // Do 	any additional setup after loading the view.
    }
    
    
    @objc func doneGesture(_ sender: UIGestureRecognizer){
        let value = timeDial.countDownDuration
        timeSet = value.magnitude
        print("timer set to \(timeSet)")
        self.delegate?.setCountdown(with: timeSet!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
