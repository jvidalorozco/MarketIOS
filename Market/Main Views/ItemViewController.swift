//
//  ItemViewController.swift
//  Market
//
//  Created by jorge on 10/6/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var collectionImage: UICollectionView!
    //MARK: Vars
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: ViewLyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPictures()
    }
    
    //MARK: Download pictures
    private func downloadPictures(){
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.collectionImage.reloadData()
                }
            }
        }
    }
    
    //MARK: SetupUI
    private func setupUI(){
        if item != nil{
            self.title = item.name
            self.nameLabel.text = item.name
            self.priceLabel.text = convertToCurrencty(item.price)
            self.descriptionTextView.text = item.description
        }
    }
    
}

extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0{
           cell.setupImageWith(itemImages[indexPath.row])
        }
       return cell
    }
       
    
}
