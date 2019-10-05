//
//  AddItemViewController.swift
//  Market
//
//  Created by Administrador on 10/4/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var titleTextField      : UITextField!
    @IBOutlet weak var priceTextField      : UITextField!
    @IBOutlet weak var descriptionTextView : UITextView!
    
    //MARK: Vars
    var category           : Category!
    var itemImages         : [UIImage?] = []
    var gallery            : GalleryController!
    let hud                = JGProgressHUD(style: .dark)
    var activityIndicator  : NVActivityIndicatorView?
    
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color:UIColor.red, padding: nil)
    }
    
    
    //MARK: IBActions
    
    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
        dismissKeyboard()
        
        if fieldsAreCompleted(){
            saveToFirebase()
        }else{
            print("Error all fields are requeried")
            //TODO: Show error to the user
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Helpers Functions
    private func fieldsAreCompleted() -> Bool{
        return(titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func popTheView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Save Item
    private func saveToFirebase(){
        
        showLoadingActivityIndicator()
        
        let item           = Item()
        item.id            = UUID().uuidString
        item.name          = titleTextField.text!
        item.categoryId    = category.id
        item.description   = descriptionTextView.text!
        item.price         = Double(priceTextField.text!)
        
        if itemImages.count > 0 {
            uploadImages(images: itemImages, itemId: item.id) { (imageLinksArray) in
                item.imageLinks = imageLinksArray
                saveItemToFirestore(item)
                self.hideLoadingActivityIndicator()
                self.popTheView()
            }
        }else{
            saveItemToFirestore(item)
            self.hideLoadingActivityIndicator()
            popTheView()
        }
        
    }
 
    //MARK: Activity Indicator
    func showLoadingActivityIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    func hideLoadingActivityIndicator(){
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    
    
    //MARK: Show gallery
    private func showImageGallery() {
        self.gallery          = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow        = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        self.present(self.gallery, animated: true, completion: nil) 
    }
    
}

  //MARK: Extensions
extension AddItemViewController : GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0{
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
