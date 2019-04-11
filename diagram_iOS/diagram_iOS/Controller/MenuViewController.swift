//
//  MenuViewController.swift
//  Main
//
//  Created by Gaurav Pai on 17/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    
    
    var menuView : UITableView!
    var cellId = "menuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifureMenuView()

        // Do any additional setup after loading the view.
    }
    
    func congifureMenuView(){
//
        menuView = UITableView()
        menuView.delegate = self
        menuView.dataSource = self
        view.addSubview(menuView)
        menuView.register(MenuOptionCell.self, forCellReuseIdentifier: cellId)
        
        //auto layout constraint
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        menuView.separatorStyle = .none
        menuView.rowHeight = 90
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
    
extension MenuViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuOptionCell
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.menuImage.image = menuOption?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        print("Clicked Menu")
        HomeViewController.delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
}
    
class MenuOptionCell: UITableViewCell {
    
    //MARK: - Properties
    let menuImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel : UILabel! = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Sample text"
        
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        addSubview(menuImage)
        menuImage.translatesAutoresizingMaskIntoConstraints = false
        menuImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        menuImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        menuImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        menuImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: menuImage.rightAnchor, constant: 10).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK - Handlers
    
    
}


