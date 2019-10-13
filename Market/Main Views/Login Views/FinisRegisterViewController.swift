//
//  FinisRegisterViewController.swift
//  Market
//
//  Created by jorge on 12/10/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinisRegisterViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
   
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    
    //MARK: - IBActions
    @IBAction func buttonDondePressed(_ sender: Any) {
       finishOnBoarding()
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Funcions
    @objc func textFieldDidChange(_ textField: UITextField){
        updateDoneButtonStatus()
    }
    
    //MARK: - Helpers
    private func updateDoneButtonStatus(){
        if nameTextField.text != "" && surNameTextField.text != "" && addressTextField.text != "" {
            doneButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            doneButton.isEnabled = true
        }else{
            doneButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            doneButton.isEnabled = false
        }
    }
    
    private func finishOnBoarding(){
        
        let withValues = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surNameTextField.text!, kONBOARD: true, kFULLADDRESS: addressTextField.text!, kFULLNAME: (nameTextField.text! + " " + surNameTextField.text!)] as [String : Any]
        
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            if error == nil {
                self.hud.textLabel.text = "Updated!"
                self.hud.indicatorView  = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                self.dismiss(animated: true, completion: nil)
            }else{
                self.hud.textLabel.text = "error updating user \(error!.localizedDescription)!"
                self.hud.indicatorView  = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
         
            }
        }
        
    }
}
