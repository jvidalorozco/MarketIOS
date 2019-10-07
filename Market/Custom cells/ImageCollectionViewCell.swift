//
//  ImageCollectionViewCell.swift
//  Market
//
//  Created by jorge on 10/6/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func setupImageWith(_ itemImage: UIImage){
        imageView.image = itemImage
    }
    
}
