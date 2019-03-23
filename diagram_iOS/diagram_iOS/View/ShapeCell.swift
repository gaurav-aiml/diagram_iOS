//
//  ShapeCell.swift
//  Main
//
//  Created by Gaurav Pai on 21/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import UIKit

class ShapeCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addShapesToSlider()
        setupCellView()
    }
    
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints=false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    // MARK: - Handlers
    func setupCellView()
    {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
