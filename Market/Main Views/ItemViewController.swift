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
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "basket"), style: .plain, target: self, action: #selector(self.addToBasketButtonPressed))]
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
    
    //MARK: - IBActions
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToBasketButtonPressed(){
        
        //TODO: Check if user is logged
        downloadBasketFromFirestore("1234") { (basket) in
               if basket == nil {
                   self.createNewBasket()
               }else{
                   basket!.itemIds.append(self.item.id)
                   self.updateBasket(basket: basket!, withValues: [kITEMSIDS : basket!.itemIds])
               }
           }
    }
    
    
    //MARK: - Add to basket
    private func createNewBasket(){
        let newBasket      = Basket()
        newBasket.id       = UUID().uuidString
        newBasket.ownerId  = "1234"
        newBasket.itemIds  = [self.item.id]
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text     = "Added to basket!"
        self.hud.indicatorView      = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
     
    }
    
    private func updateBasket(basket: Basket, withValues: [String: Any]){
        updateBasketInFirestore(basket, withValues: withValues) { (error) in
            if error != nil {
                self.hud.textLabel.text     = "error updating basket \(error!.localizedDescription)"
                self.hud.indicatorView      = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                print("error updating basket \(error!.localizedDescription)")
            }else{
                self.hud.textLabel.text     = "Added to basket!"
                self.hud.indicatorView      = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
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
