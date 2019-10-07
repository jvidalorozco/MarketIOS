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
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let itemsPerRow : CGFloat = 1
    private let cellHeight : CGFloat = 196.0
    
    
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

extension ItemViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let avaliableWidth = collectionView.frame.width - sectionInsets.left

        return CGSize(width: avaliableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
