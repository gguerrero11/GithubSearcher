//
//  SearchTableViewController.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let manager = UsersManager()
    let userCellId = "userCell"
    var userArray = [User]()
    
    var selectedIndex = -1
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        searchBar.delegate = self
        
        title = "GitHub Users"
        
        manager.updatedSearchCallback = {
            self.userArray = self.manager.searchResults
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        manager.usersDownloadCallback = {
            self.userArray = self.manager.users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let userCell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as? UserTableViewCell {
            let user = userArray[indexPath.row]
            
            if let userProf = user.userProfile, let repoCount = userProf.repoCount {
                userCell.repoCountLabel.text = String(repoCount)
            } else {
                userCell.repoCountLabel.text = "0"
                manager.getUserProfile(forUser: user) {
//                    print("reloading \(indexPath.row)")
//                    print("\(self.userArray[indexPath.row].userProfile)")
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
                        
            userCell.userNameLabel.text = user.username
            userCell.profilePicImageView.setImageURL(string: user.imageURL)
            return userCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

  // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailPush", sender: indexPath)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailTableViewController {
            if let indexPath = sender as? IndexPath {
                dest.user = manager.users[indexPath.row]
                dest.manager = manager
            }
        }
    }

}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        manager.handleSearch(word: searchText)
        userArray = (searchText == "") ? manager.users : manager.searchResults
    }
}
