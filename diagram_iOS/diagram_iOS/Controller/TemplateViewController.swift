//
//  TemplateViewController.swift
//  diagram_iOS
//
//  Created by Gaurav Pai on 13/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class TemplateViewController: UIViewController {
    
    let cellId = "templateCollection"
    let templateTable: UITableView =
    {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        table.backgroundColor = UIColor .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        templateTable.delegate = self
        templateTable.dataSource = self
        templateTable.register(TemplateCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(templateTable)
        setupTemplateCollectionLayout()
        
        templateTable.separatorStyle = .none
        templateTable.rowHeight = 90
        

        // Do any additional setup after loading the view.
    }

//    // MARK:- Handlers
//
    private func setupTemplateCollectionLayout()
    {

        //shapeCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //shapeCollection.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        templateTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        templateTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        templateTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        templateTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
    }
    
}



extension TemplateViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TemplateCell
        let templateItem = templateItems(rawValue: indexPath.row)
        cell.templateLabel.text = templateItem?.description
        cell.templateTextField.tag = indexPath.row
        return cell
    }
    
    
    
}

class TemplateCell : UITableViewCell {
    
    let templateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    let templateTextField : UITextField! = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.placeholder = "Enter Here"
        textField.backgroundColor = #colorLiteral(red: 1, green: 0.8922966031, blue: 0.6439055556, alpha: 1)
        return textField
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.7251796473, green: 0.5768737038, blue: 0.8039215803, alpha: 1)
        
        addSubview(templateLabel)
        addSubview(templateTextField)
        templateLabel.translatesAutoresizingMaskIntoConstraints = false
        templateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        templateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        templateLabel.rightAnchor.constraint(equalTo: templateTextField.leftAnchor , constant: -10).isActive = true
        templateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        templateTextField.translatesAutoresizingMaskIntoConstraints = false
        templateTextField.leftAnchor.constraint(equalTo: templateLabel.rightAnchor, constant: 10).isActive = true
        templateTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        templateTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
