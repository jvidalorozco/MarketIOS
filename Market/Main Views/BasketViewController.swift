//
//  BasketViewController.swift
//  Market
//
//  Created by Administrador on 10/9/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {
   
    //MARK - IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    
    //MARK: - Vars
    var basket: Basket?
    var allitems: [Item]  = []
    var purcharsedItemIds : [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableview.tableFooterView = footerView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: Check if user is logged in
        
    }
    
    
    //MARK: IBActions
    @IBAction func checkoutPressed(_ sender: Any) {
        
    }
    
    
    //MARK: -Download basket
    private func loadBasketFromFirestore(){
        downloadBasketFromFirestore("1234") { (basket) in
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems(){
        if basket != nil {
            downloadItemsFromFirebase(<#T##withCategoryId: String##String#>, completion: <#T##([Item]) -> Void#>)
        }
    }
 
}

extension BasketViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
