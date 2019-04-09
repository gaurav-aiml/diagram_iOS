//
//  BottleneckViewController.swift
//  diagram_iOS
//
//  Created by Vishal Hosakere on 03/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class BottleneckViewController: UIViewController {
    
    var menuView : UITableView!
    var cellId = "menuCell"
    var nextButton: UIButton!
    var basicBarChart: BasicBarChart!
    var alternateChart: BeautifulBarChart!
    var titleLabel : UILabel!
    var toggle: UIButton!
    var save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        congifureMenuView()
        configureBarChart()
        self.view.backgroundColor = .white
        nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        nextButton.setTitle("Next", for: UIControl.State.normal)
        nextButton.backgroundColor = .black
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: UIControl.Event.touchUpInside)
        nextButton.center = CGPoint(x: self.view.frame.width - 150, y: self.view.frame.height - 85)

    
        toggle = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        toggle.setTitle("Toggle", for: UIControl.State.normal)
        toggle.backgroundColor = .black
        toggle.addTarget(self, action: #selector(toggleTapped), for: UIControl.Event.touchUpInside)
        toggle.center = CGPoint(x: self.view.frame.width - 260, y: self.view.frame.height - 85)
        toggle.isHidden = true
        
        save = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        save.setTitle("Save", for: UIControl.State.normal)
        save.backgroundColor = .black
        save.addTarget(self, action: #selector(saveTapped), for: UIControl.Event.touchUpInside)
        save.center = CGPoint(x: self.view.frame.width - 370, y: self.view.frame.height - 85)
        save.isHidden = true
        
        
        self.view.addSubview(nextButton)
        self.view.addSubview(toggle)
        self.view.addSubview(save)
        self.basicBarChart.isHidden = true
        self.titleLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @objc func toggleTapped(_ sender: UIGestureRecognizer){
        basicBarChart.isHidden = !basicBarChart.isHidden
        alternateChart.isHidden = !alternateChart.isHidden
    }
    
    @objc func saveTapped(_ sender: UIGestureRecognizer){
        if !basicBarChart.isHidden{
            basicBarChart.exportAsImage()
        }
        if !alternateChart.isHidden{
            alternateChart.exportAsImage()
        }
    }
    
    
    @objc func nextButtonTapped(_ sender: UIGestureRecognizer){
        DispatchQueue.main.async {
            self.toggle.isHidden = !self.toggle.isHidden
            self.save.isHidden = !self.save.isHidden
            if self.menuView.isHidden == false{
                self.menuView.isHidden = true
                self.nextButton.setTitle("Previous", for : UIControl.State.normal)
                self.basicBarChart.isHidden = false
                self.titleLabel.isHidden = false
            }
            else{
                self.menuView.isHidden = false
                self.nextButton.setTitle("Next", for : UIControl.State.normal)
                self.basicBarChart.isHidden = true
                self.titleLabel.isHidden = true
            }
        }	
    }
    
    func configureBarChart(){
        titleLabel = UILabel(frame: CGRect(x: 0, y: 70, width: self.view.frame.width, height: 70))
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.text = " Bar Chart indicating the bottleneck"
        titleLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(titleLabel)
        basicBarChart = BasicBarChart(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 400))
        alternateChart = BeautifulBarChart(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 400))
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [BarEntry] = []
        var maxValue = 0
        let bottleneckFiles = BottleneckFiles()
        for i in 0..<bottleneckFiles.FilesArray.count {
            let value = bottleneckFiles.FilesArray[i].1
            maxValue = maxValue < value ? value : maxValue
        }
        
        for i in 0..<bottleneckFiles.FilesArray.count {
            let value = bottleneckFiles.FilesArray[i].1
            let height: Float = Float(value) / Float(maxValue)
            
            let label = bottleneckFiles.FilesArray[i].0
            result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: label))
        }
        basicBarChart.dataEntries = result
        alternateChart.dataEntries = result
        alternateChart.isHidden = true
        self.view.addSubview(basicBarChart)
        self.view.addSubview(alternateChart)
    }
    
    func congifureMenuView(){
        //
        let title : UILabel! = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 24)
            label.text = " Process and its output count"
            label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            return label
        }()
        menuView = UITableView()
        menuView.delegate = self
        menuView.dataSource = self
        menuView.tableHeaderView = title
        view.addSubview(menuView)
        menuView.register(MenuOptionCell2.self, forCellReuseIdentifier: cellId)
        
        
        //auto layout constraint
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        menuView.separatorStyle = .singleLine
        menuView.rowHeight = 70
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

//MAKR: - Handlers

extension BottleneckViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let bottleneckFiles = BottleneckFiles()
        return bottleneckFiles.FilesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuOptionCell2
        let bottleneckFiles = BottleneckFiles()
        
        let menuOption = bottleneckFiles.FilesArray[indexPath.row]
        cell.processName.text = menuOption.0
        cell.outputCount.text = String(menuOption.1)
        return cell
    }
}

class MenuOptionCell2: UITableViewCell {
    
    //MARK: - Properties
    let processName : UILabel! = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Sample text"
        
        return label
    }()
    
    let outputCount : UILabel! = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Sample text"
        
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        addSubview(processName)
        processName.translatesAutoresizingMaskIntoConstraints = false
        processName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        processName.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        processName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        processName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(outputCount)
        outputCount.translatesAutoresizingMaskIntoConstraints = false
        outputCount.leftAnchor.constraint(equalTo: processName.rightAnchor, constant: 10).isActive = true
        outputCount.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK - Handlers

}
