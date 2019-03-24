//
//  SlideViewController.swift
//  Main
//
//  Created by Gaurav Pai on 20/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {
    
    let cellId = "cellId"
    private var shapesCreated: Bool = false
    private let shapes = ["rectangle", "rounded rectangle", "database", "rhombus", "harddisk"]
    
    let shapeCollection: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = UIColor .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        shapeCollection.delegate = self
        shapeCollection.dataSource = self
        shapeCollection.dragDelegate = self
        shapeCollection.register(ShapeCell.self, forCellWithReuseIdentifier: cellId )
        view.addSubview(shapeCollection)
        setupShapeCollectionLayout()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupShapeCollectionLayout(){
        
        //shapeCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //shapeCollection.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        shapeCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        shapeCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        shapeCollection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        shapeCollection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
}

    // MARK: - Handlers
    

extension SlideViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate
{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    func dragItems(at indexPath: IndexPath) -> [UIDragItem]
    {
        if let img = (shapeCollection.cellForItem(at: indexPath) as? ShapeCell)?.imageView.image
        {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: img))
            dragItem.localObject = img
            return [dragItem]
        }
        else
        {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return shapes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = shapeCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShapeCell
        let shape = UIImage(named: shapes[indexPath.row])
        cell.imageView.image = shape
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 120 , height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
     }
}



