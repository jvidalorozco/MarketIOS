//
//  PurcharsedHistoryTableViewController.swift
//  Market
//
//  Created by jorge on 13/10/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class PurcharsedHistoryTableViewController: UITableViewController {

    
    //MARK: - Vars
    var itemArray : [Item] = []
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPurcharsedItems", for: indexPath) as! ItemsTableViewCell
       
        cell.generateCell(itemArray[indexPath.row])

        return cell
    }


    //MARK: - Load Items
    private func loadItems(){
        downloadItems(MUser.currentUser()!.purcharsedItemIds) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
   
}


//MARK: Empty Datasource
extension PurcharsedHistoryTableViewController : EmptyDataSetSource, EmptyDataSetDelegate {
 
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No item to display")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please check back later")
    }
}
