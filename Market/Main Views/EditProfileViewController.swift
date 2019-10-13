//
//  EditProfileViewController.swift
//  Market
//
//  Created by jorge on 12/10/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
class EditProfileViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.loadUserInfo()
        }
        
    }
    
    //MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: Any) {
       logoutUser()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dismissKeyBoard()
        if textFieldsHaveText() {
             let withValues = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surnameTextField.text!, kONBOARD: true, kFULLADDRESS: addressTextField.text!, kFULLNAME: (nameTextField.text! + " " + surnameTextField.text!)] as [String : Any]
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                if error == nil {
                    self.hud.textLabel.text = "Updated!"
                    self.hud.indicatorView  = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay:2.0)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.hud.textLabel.text = error?.localizedDescription
                    self.hud.indicatorView  = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay:2.0)
                }
            }
                  
        }else{
            hud.textLabel.text = "All fields are required"
            hud.indicatorView  = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay:2.0)
        }
    }
    
    
    //MARK: - UpdateUI
    private func loadUserInfo(){
        
        if MUser.currentUser() != nil {
            let currentUser = MUser.currentUser()!
            nameTextField.text = currentUser.firstName
            surnameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddress
            
        }
        
    }
    
    //MARK: Helper funcs
    private func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    
    private func textFieldsHaveText()-> Bool{
        return nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != ""
    }
    
    private func logoutUser(){
        MUser.logOutCurrentUser { (error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }else{
                print("error login out", error?.localizedDescription)
            }
        }
    }
}
