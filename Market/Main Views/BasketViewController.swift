//
//  BasketViewController.swift
//  Market
//
//  Created by Administrador on 10/9/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import JGProgressHUD
import Stripe

class BasketViewController: UIViewController {
   
    //MARK - IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    
    //MARK: - Vars
    var basket: Basket!
    var allitems: [Item]  = []
    var purcharsedItemIds : [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    var totalPrice = 0
//    var enviroment: String = PayPalEnvironmentNoNetwork {
//            willSet (newEnviroment){
//                if (newEnviroment != enviroment){
//                    PayPalMobile.preconnect(withEnvironment: newEnviroment)
//                }
//            }
//    }
//
//    var payPalConfig = PayPalConfiguration()
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableview.tableFooterView = footerView
       // setupPaypal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if MUser.currentUser() != nil {
            self.loadBasketFromFirestore()
        }else{
            self.updateTotalLabels(true)
        }
        
        
    }
    
    
    //MARK: IBActions
    @IBAction func checkoutPressed(_ sender: Any) {
        
        if MUser.currentUser()!.onBoard {
            showPaymentOptions()
        }else{
            self.hud.textLabel.text = "Please complete you profile!"
            self.hud.indicatorView  = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    
    //MARK: -Download basket
    private func loadBasketFromFirestore(){
        downloadBasketFromFirestore(MUser.currentId()) { (basket) in
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems(){
        if basket != nil {
            downloadItems(self.basket!.itemIds) { (allItems) in
                print("All items", allItems)
                self.allitems = allItems
                self.updateTotalLabels(false)
                self.tableview.reloadData()
            }
        }
    }
    
    //MARK: - Helper Functions
    
    
    private func updateTotalLabels(_ isEmpty: Bool){
        
        if isEmpty {
            totalItemsLabel.text = "0"
        }else{
            totalItemsLabel.text = "\(allitems.count)"
        }
         totalLabel.text      = returnBasketTotalPrice()
         
        checkoutButtonStatusUpdate()
    }
    
    private func returnBasketTotalPrice() -> String{
        var totalPrice = 0.0
        for item in allitems {
            totalPrice += item.price
        }
        return "Total price: \(convertToCurrencty(totalPrice))"
    }
    
    private func emptyTheBasket() {
        purcharsedItemIds.removeAll()
        allitems.removeAll()
        tableview.reloadData()
        
        basket!.itemIds = []
        updateBasketInFirestore(basket!, withValues: [kITEMSIDS: basket!.itemIds]) { (error) in
            if error != nil {
                print("Error updating basket", error!.localizedDescription)
            }
            self.getBasketItems()
        }
    }
    
    private func addItemsToPurcharsedHistory(_ itemIds: [String]){
        if MUser.currentUser() != nil {
            let newItemIds = MUser.currentUser()!.purcharsedItemIds + itemIds
            updateCurrentUserInFirestore(withValues: [kPURCHARSEDITEMIDS: newItemIds]) { (error) in
                if error != nil {
                    print("Error adding purcharsed items",error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Navigation
      private func showItemView(_ withItem: Item){
           let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
            itemVC.item = withItem
           
           self.navigationController?.pushViewController(itemVC, animated: true)
       }
       
    
    //MARK: - Control checkout button
    private func checkoutButtonStatusUpdate(){
        checkoutButton.isEnabled = allitems.count > 0
        if checkoutButton.isEnabled {
            checkoutButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
         disableCheckOutButton()
        }
    }
    
    private func disableCheckOutButton(){
        checkoutButton.isEnabled = false
        checkoutButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    private func removeItemFromBasket(itemId: String){
        
        for i in 0..<basket!.itemIds.count {
            if itemId == basket!.itemIds[i]{
                basket!.itemIds.remove(at: i)
                return
            }
        }
        
    }
    
    //MARK: - Stripe
//    private func setupPaypal(){
//        payPalConfig.acceptCreditCards = false
//        payPalConfig.merchantName      = "MarketDev"
//        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//        payPalConfig.merchantUserAgreementURL = URL(string:"https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//        payPalConfig.payPalShippingAddressOption = .both
//    }
    
    private func finishPayment(token: STPToken){
        self.totalPrice = 0
        for item in allitems {
         
            purcharsedItemIds.append(item.id)
            self.totalPrice += Int(item.price)
            
        }
        self.totalPrice = self.totalPrice * 100
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: self.totalPrice) { (error) in
            if error == nil {
                self.emptyTheBasket()
                self.addItemsToPurcharsedHistory(self.purcharsedItemIds)
                
                //Show notification
                self.showNotification(text: "Payment succ!ess!", isError: false)
            }else{
                print("error",error!.localizedDescription)
            }
        }
    }
    
    private func showNotification(text : String, isError: Bool){
        
        if isError {
          self.hud.indicatorView  = JGProgressHUDErrorIndicatorView()
        }else{
          self.hud.indicatorView  = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    func showPaymentOptions() {
        let alertController = UIAlertController(title: "Payment Optiones", message: "Choose prefred payment option", preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Pay with Card", style: .default) { (action) in
            
            //show card number view
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(cardAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension BasketViewController : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellbasket", for: indexPath) as! ItemsTableViewCell
        
        cell.generateCell(allitems[indexPath.row])
        
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = allitems[indexPath.row]
            allitems.remove(at: indexPath.row)
            tableView.reloadData()
            removeItemFromBasket(itemId: itemToDelete.id)
            updateBasketInFirestore(basket!, withValues: [kITEMSIDS : basket!.itemIds]) { (error) in
                if error != nil{
                    print("error updating the basket", error!.localizedDescription)
                }
                self.getBasketItems()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(allitems[indexPath.row])
    }
}


//MARK: Helper extensions

extension BasketViewController : PayPalPaymentDelegate {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentViewController.dismiss(animated: true) {
            self.addItemsToPurcharsedHistory(self.purcharsedItemIds)
            self.emptyTheBasket()
        }
    }
    
    
}
