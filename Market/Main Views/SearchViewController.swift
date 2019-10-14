//
//  SearchViewController.swift
//  Market
//
//  Created by jorge on 14/10/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchViewController: UIViewController {
   
    //MARK: -IBOutlets
    @IBOutlet weak var searchOptionsView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableViewSearch: UITableView!
    
    //MARK: Vars
    var searchResults: [Item] = []
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: -View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSearch.tableFooterView = UIView()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color:UIColor.red, padding: nil)
    }
    
    
    
    //MARK: -IBActions
    @IBAction func searchButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func searchBarButtonClick(_ sender: Any) {
        dismissKeyBoard()
        showSearchField()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: -Helpers
    private func showSearchField(){
        disableSearchButton()
        emptyTextField()
        animateSeachtOptionsIn()
    }
    
    private func dismissKeyBoard(){
         self.view.endEditing(true)
    }
    
    private func emptyTextField(){
        self.searchTextField.text = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        searchButton.isEnabled = textField.text != ""
        
        if searchButton.isEnabled {
            searchButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }else{
            disableSearchButton()
        }
       
    }
    
    private func disableSearchButton(){
        searchButton.isEnabled = false
        searchButton.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    //MARK: Animations
    private func animateSeachtOptionsIn(){
        UIView.animate(withDuration: 0.5) {
            self.searchOptionsView.isHidden = !self.searchOptionsView.isHidden
        }
    }

     //MARK: Activity Indicator
       func showLoadingActivityIndicator(){
           if activityIndicator != nil {
               self.view.addSubview(activityIndicator!)
               activityIndicator!.startAnimating()
           }
       }
       func hideLoadingActivityIndicator(){
           if activityIndicator != nil {
               activityIndicator!.removeFromSuperview()
               activityIndicator!.stopAnimating()
           }
       }
    
    private func showItemView(withItem: Item){
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
       
}




//MARK: -TableView Datasource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSearch", for: indexPath) as! ItemsTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
    }
    
    //TableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: searchResults[indexPath.row])
    }
    
    
    
    
}
