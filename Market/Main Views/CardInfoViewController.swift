//
//  CardInfoViewController.swift
//  Market
//
//  Created by MacBook Pro on 10/21/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import Stripe

protocol CardInfoViewControllerDelegate {
    
    func didClickDone(_ token: STPToken)
    func didClickCancel()
    
}


class CardInfoViewController: UIViewController {

    
    //MARK: IBOutlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Vars
    let paymentCardTextField = STPPaymentCardTextField()
    public var delegate : CardInfoViewControllerDelegate?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(paymentCardTextField)
        
        self.paymentCardTextField.delegate = self
        
        self.paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .top, relatedBy: .equal, toItem: doneButton, attribute: .bottom, multiplier: 1, constant: 30))
        self.view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))
        self.view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20))
    }
    //MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: Any) {
   
        
        delegate?.didClickCancel()
        dissmissView()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        processCard()
    }
    
    //MARK: Helpers
    private func dissmissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func processCard(){
        
        let cardParams = STPCardParams()
        cardParams.number = self.paymentCardTextField.cardNumber
        cardParams.expMonth = self.paymentCardTextField.expirationMonth
        cardParams.expYear = self.paymentCardTextField.expirationYear
        cardParams.cvc = self.paymentCardTextField.cvc
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            
            if error == nil {
                self.delegate?.didClickDone(token!)
                self.dissmissView()
            }else{
                print("Error processing card token", error!.localizedDescription)
            }
            
        }
    }
}


//MARK: Extensions

extension CardInfoViewController: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        doneButton.isEnabled = textField.isValid
        
    }
}
