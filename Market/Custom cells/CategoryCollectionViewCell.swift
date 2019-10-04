//
//  CategoryCollectionViewCell.swift
//  Market
//
//  Created by Administrador on 10/3/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func generateCell(_ category: Category){
        nameLabel.text  = category.name
        imageView.image = category.image
    }
}
