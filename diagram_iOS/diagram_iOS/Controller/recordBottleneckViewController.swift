//
//  recordBottleneckViewController.swift
//  diagram_iOS
//
//  Created by Vishal Hosakere on 03/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class recordBottleneckViewController: UIViewController {

    var inputProcessView : processView!
    var seconds: Int!
    var _seconds: Int!
    var timerLabel: UILabel!
    var start: UIButton!
    var pause: UIButton!
    var done: UIButton!
    var reset: UIButton!
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    var outputField : UITextField!
    var notesField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _seconds = seconds
        self.view.backgroundColor = .lightGray
        let copyProcess = processView(frame: CGRect(x: 50, y: 200, width: 200, height: 200), ofShape: inputProcessView.shape!, withID: 0, withText: inputProcessView.textView.text)
        copyProcess.isUserInteractionEnabled = false
        self.view.addSubview(copyProcess)
        
        timerLabel = UILabel(frame: CGRect(x: self.view.frame.width - 400, y: 300 , width: 150, height: 100))
        let labelData = timeString(time: TimeInterval(seconds))
        timerLabel.backgroundColor = .lightGray
        timerLabel.text = labelData
        timerLabel.textAlignment = .left
        timerLabel.textColor = .black
        timerLabel.font = timerLabel.font.withSize(50)
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.sizeToFit()
        self.view.addSubview(timerLabel)
        
        start = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        start.center = self.view.center
        start.setTitle("Start", for: UIControl.State.normal)
        start.addTarget(self, action: #selector(startButtonTapped), for: UIControl.Event.touchUpInside)
        start.backgroundColor = .black
        
        reset = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        reset.center = CGPoint(x: self.view.center.x + 150, y: self.view.center.y)
        reset.setTitle("Reset", for: UIControl.State.normal)
        reset.addTarget(self, action: #selector(resetButtonTapped), for: UIControl.Event.touchUpOutside)
        reset.backgroundColor = .black
        
        pause = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        pause.center = CGPoint(x: self.view.center.x - 150, y: self.view.center.y)
        pause.setTitle("Pause", for: UIControl.State.normal)
        pause.addTarget(self, action: #selector(pauseButtonTapped), for: UIControl.Event.touchUpInside)
        pause.isEnabled = false
        pause.backgroundColor = .black
        
        self.view.addSubview(start)
        self.view.addSubview(pause)
        self.view.addSubview(reset)
        
        outputField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
        outputField.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 100)
        outputField.borderStyle = .bezel
        outputField.textAlignment = .center
        outputField.keyboardType = .numberPad
        outputField.isHidden = true
        outputField.font = outputField.font?.withSize(25)
        outputField.placeholder = "Total Output"
        self.view.addSubview(outputField)
        
        notesField = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: 200))
        notesField.textAlignment = .justified
        notesField.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 250)
        notesField.font = UIFont.systemFont(ofSize: 20)
        notesField.text = "\(inputProcessView.textView.text ?? "Unknown Process") : \n\n"
        self.view.addSubview(notesField)
        
        done = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        done.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 400)
        done.setTitle("Done", for: UIControl.State.normal)
        done.addTarget(self, action: #selector(doneButtonTapped), for: UIControl.Event.touchUpInside)
        done.isHidden = true
        done.backgroundColor = .black
        
        self.view.addSubview(done)
        
        alreadyHasData()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pause.isEnabled = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            outputField.isHidden = false
            done.isHidden = false
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format :"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @objc func pauseButtonTapped(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            self.pause.setTitle("Resume",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            self.pause.setTitle("Pause",for: .normal)
        }
    }
    
    @objc func doneButtonTapped(_ sender: UIButton) {
        if outputField.text != ""{
            writeToFile()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.start.isEnabled = false
        }
    }
    
    @objc func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pause.isEnabled = false
    }
    
    
    
    func writeToFile(){
        let fileName = String(describing: inputProcessView.processID!)
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("notes.txt")
        let fileURL2 = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("count.txt")
        print(fileURL)
        var text = notesField.text!
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("failed with error: \(error)")
        }
        
        text = "\(inputProcessView.textView.text!)$$\(outputField.text!)"
        
        do {
            try text.write(to: fileURL2, atomically: true, encoding: .utf8)
        } catch {
            print("failed with error: \(error)")
        }
        

    }
    
    
    func alreadyHasData(){
        let fileName = String(describing: inputProcessView.processID!)
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("notes.txt")
        let fileURL2 = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("count.txt")
        
        let fileManager  = FileManager.default
        
        do {
            let text1 = try String(contentsOf: fileURL, encoding: .utf8)
            notesField.text = text1
            //print("Read back text: \(text2)")
        }
        catch {
            print("failed with error: \(error)")
        }
        
        do {
            let text2 = try String(contentsOf: fileURL2, encoding: .utf8)
            let splitText = text2.components(separatedBy: "$$")
            if splitText.count == 2{
                outputField.text = splitText[1]
                outputField.isHidden = false
            }
            //print("Read back text: \(text2)")
        }
        catch {
            print("failed with error: \(error)")
        }
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
