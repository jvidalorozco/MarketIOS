//
//  ItemsTableViewCell.swift
//  Market
//
//  Created by jorge on 10/6/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var imgImageItem: UIImageView!
    @IBOutlet weak var nameItem: UILabel!
    @IBOutlet weak var descriptionItem: UILabel!
    @IBOutlet weak var valueItem: UILabel!
    
    func generateCell(_ item: Item){
        nameItem.text        =  item.name
        descriptionItem.text =  item.description
        valueItem.text       = convertToCurrencty(item.price)
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            downloadImages(imageUrls: [item.imageLinks.first!]) { (arrayImages) in
                self.imgImageItem.image = arrayImages.first as? UIImage
            }
        }
    }

}
