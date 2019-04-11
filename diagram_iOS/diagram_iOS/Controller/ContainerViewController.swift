//
//  ContainerViewController.swift
//  Main
//
//  Created by Gaurav Pai on 17/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    
    
    // MARK: - Properties
    var blurEffectView: UIVisualEffectView!
    var blurEffect : UIBlurEffect!
    var menuViewController : UIViewController!
    var homeViewController: UIViewController!
    var navController : UIViewController!
    var isExpanded = false
    static var menuDelegate : menuControllerDelegate?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        configureHomeController()
        configureBlurEffect()
        self.modalTransitionStyle = .crossDissolve
        print(LandingPageViewController.projectName)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Handlers
    
    func configureBlurEffect(){
        
        blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = homeViewController.view.frame
        
    }
    
    func configureHomeController()
    {
        
        homeViewController = HomeViewController()
        HomeViewController.delegate = self
        navController = UINavigationController(rootViewController: homeViewController)
        //setupHomeViewLayout()
        view.addSubview(navController.view)
        addChild(navController)
        didMove(toParent: self)
    }
    
//    func setupHomeViewLayout(){
//
//        let homeView = homeViewController.view!
//        navController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        navController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        navController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        navController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//    }
    
    func configureMenuController()
    {
         
        if menuViewController == nil
        {
            menuViewController = MenuViewController()
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
            menuViewController.didMove(toParent: self)
        }
        
    }
    
    func showMenuController(shouldExpand: Bool, menuOption: MenuOption?)
    {
        // Configuring the Blur Effect
        if shouldExpand
        {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations:{
                self.navController.view.frame.origin.x = self.navController.view.frame.width/2 }, completion: nil)
            print("Animating Out")
            homeViewController.view.addSubview(blurEffectView)
        }
        else
        {
            print("Animating Back")
            blurEffectView.removeFromSuperview()
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.navController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(forMenuOption: menuOption)
            }
            
        }

    }
    
    func didSelectMenuOption(forMenuOption menuOption: MenuOption){
        switch menuOption{
        case .Save:
            ContainerViewController.menuDelegate!.saveViewState()
        case .SaveAs:
            ContainerViewController.menuDelegate!.saveViewStateAsNew()
        case .Screenshot:
            ContainerViewController.menuDelegate!.takeScreenShot()
        case .ExportPDF:
            ContainerViewController.menuDelegate!.exportAsPDF()
        }
    }
    
}

extension ContainerViewController: HomeControllerDelegate
{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        
        if !isExpanded
        {
            configureMenuController()
        }
        isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
