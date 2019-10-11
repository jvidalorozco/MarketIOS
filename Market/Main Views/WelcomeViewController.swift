//
//  WelcomeViewController.swift
//  Market
//
//  Created by Administrador on 10/10/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {
     
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButtonOutlet: UIButton!
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1.0), padding: nil)
    }
    
    //MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dissmisView()
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if textFieldHaveText() {
              loginUser()
         }else{
           hud.textLabel.text = "All fields are required"
           hud.indicatorView  = JGProgressHUDErrorIndicatorView()
           hud.show(in: self.view)
           hud.dismiss(afterDelay: 2.0)
       }
       
    }
    
    @IBAction func registerBottonPressed(_ sender: Any) {
        if textFieldHaveText() {
            registerUser()
        }else{
            hud.textLabel.text = "All fields are required"
            hud.indicatorView  = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
    }
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        
    }
    
    //MARK: - Register user
    
    private func registerUser(){
        showLoadingIndicator()
        MUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error == nil{
                self.hud.textLabel.text = "Verification Email sent!"
                self.hud.indicatorView  = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }else{
                self.hud.textLabel.text = "Error registering: \(error?.localizedDescription)"
                self.hud.indicatorView  = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideLoadingIndicator()
        }
    }
    //MARK: - Login user
    private func loginUser(){
         self.showLoadingIndicator()
          MUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            if error == nil {
                if isEmailVerified {
                   self.dissmisView()
                }else{
                    self.hud.textLabel.text = "Please verify yout email!"
                    self.hud.indicatorView  = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }else{
                
                  self.hud.textLabel.text = error?.localizedDescription
                  self.hud.indicatorView  = JGProgressHUDErrorIndicatorView()
                  self.hud.show(in: self.view)
                  self.hud.dismiss(afterDelay: 2.0)
            }
           self.hideLoadingIndicator()
        }
    }
    
    
    //MARK: - Helpers
    private func textFieldHaveText() ->Bool{
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func dissmisView(){
        self.dismiss(animated: true, completion: nil)
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Activity Indicator
    private func showLoadingIndicator(){
       if activityIndicator != nil {
          self.view.addSubview(activityIndicator!)
          activityIndicator!.startAnimating()
       }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
         activityIndicator!.removeFromSuperview()
         activityIndicator!.stopAnimating()
        }
    }
    
}
