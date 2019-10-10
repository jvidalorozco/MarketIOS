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
    var basket: Basket!
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
        self.loadBasketFromFirestore()
        
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
            downloadItems(self.basket!.itemIds) { (allItems) in
                print("All items", allItems)
                self.allitems = allItems
                self.tableview.reloadData()
            }
        }
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
}
