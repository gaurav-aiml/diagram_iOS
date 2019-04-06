//
//  LandingPageViewController.swift
//  diagram_iOS
//
//  Created by Gaurav Pai on 01/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    var stackView = UIStackView()
    static var projectName = ""
    
    
    
    var createButton : UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "createNew"), for: .normal)
        button.addTarget(self, action: #selector(openNewDoc), for: .touchUpInside)
        return button
    }
    
    var loadButton : UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "load100"), for: .normal)
        button.addTarget(self, action: #selector(openNewDoc), for: .touchUpInside)
        return button
    }
    
    var recentsButton : UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "recent100"), for: .normal)
        button.addTarget(self, action: #selector(openNewDoc), for: .touchUpInside)
        return button
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.barStyle = .blackOpaque
        navigationItem.title = "Excelsior"
        addButtons()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func addButtons()
    {
        stackView.isUserInteractionEnabled = true
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 30
        
        stackView.addArrangedSubview(createButton)
        stackView.addArrangedSubview(loadButton)
        stackView.addArrangedSubview(recentsButton)
        self.view.addSubview(stackView)
        setupButtonLayout()
    }
    
    
    
    func setupButtonLayout()
    {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
        
    func setNavigationBar() {
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 80))
//        let navItem = UINavigationItem(title: "")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(createSegue))
//        navItem.rightBarButtonItem = doneItem
//        navBar.setItems([navItem], animated: false)
//        self.view.addSubview(navBar)
    }
    
    
    
    @objc func openNewDoc(){
        print("clicked")
        
        let alert = UIAlertController(title: "Enter the name of the Project", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "The name should be unique"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
        { action in
            if ((alert.textFields?.first?.text) != nil)
            {
                LandingPageViewController.projectName = alert.textFields?.first?.text as! String
                    let directory = FileHandling(name: LandingPageViewController.projectName)
                    if directory.createNewProjectDirectory()
                    {
                            print("Directory successfully created!")
                            let cont = ContainerViewController()
                            self.present(cont, animated: true)
                    }
                
            }
            
        }))
        
        self.present(alert, animated: true)
        
        
    }

}

