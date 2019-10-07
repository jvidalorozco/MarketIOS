//
//  ItemsTableViewController.swift
//  Market
//
//  Created by Administrador on 10/4/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    //MARK: Vars
    var category  : Category?
    var itemArray : [Item] = []
 
    
    //MARK: Viewlifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.title = category?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if category != nil {
           loadItems()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }
    
    //MARK: TablewView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }

  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg"{
            let vcAddItem      = segue.destination as! AddItemViewController
            vcAddItem.category = self.category!
        }
    }
    
    private func showItemView(_ item: Item){
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    
    //MARK: Load Items
    private func loadItems(){
        downloadItemsFromFirebase(category!.id) { (itemArray) in
            self.itemArray = itemArray
            self.tableView.reloadData()
        }
    }

}
