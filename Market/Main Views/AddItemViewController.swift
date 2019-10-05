//
//  AddItemViewController.swift
//  Market
//
//  Created by Administrador on 10/4/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var titleTextField      : UITextField!
    @IBOutlet weak var priceTextField      : UITextField!
    @IBOutlet weak var descriptionTextView : UITextView!
    
    //MARK: Vars
    var category   : Category!
    var itemImages : [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let item           = Item()
        item.id            = UUID().uuidString
        item.name          = titleTextField.text!
        item.categoryId    = category.id
        item.description   = descriptionTextView.text!
        item.price         = Double(priceTextField.text!)
        
        if itemImages.count > 0 {
            
        }else{
            saveItemToFirestore(item)
            popTheView()
        }
        
    }
 
}
