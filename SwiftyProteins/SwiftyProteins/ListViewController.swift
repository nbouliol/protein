//
//  ListViewController.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/27/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    var searchResult:[String]?
    @IBOutlet weak var listOfLiguands: UITableView!
//    let searchController = UISearchController(searchResultsController: nil)
//    @IBOutlet weak var searchText: UISearchBar!

    let cacas : [String] = ["caca", "caca", "caca", "caca", "caca", "pipi", "test", "fdp"]
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfLiguands.delegate = self
        listOfLiguands.dataSource = self
        
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        listOfLiguands.tableHeaderView = searchController.searchBar
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
//    https://grokswift.com/swift-tableview-search-bar/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.cacas.count 
        } else {
            return self.cacas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liguandCell", for: indexPath)
//        cell.tuple = (useri?.projects![indexPath.row]["project"]["name"].string, useri?.projects?[indexPath.row]["final_mark"].int)
        cell.textLabel?.text = cacas[indexPath.row]
        return cell
        
    }
    
    
    func filterContentForSearchText(searchText: String) {
//        // Filter the array using the filter method
//        if self.cacas == nil {
//            self.searchResult = nil
//            return
//        }
        self.searchResult = self.cacas.filter({( caca: String) -> Bool in
            // to start, let's just search by name
            return caca.lowercased().range(of: searchText.lowercased()) != nil
        })
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        self.filterContentForSearchText(searchText: searchString!)
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
