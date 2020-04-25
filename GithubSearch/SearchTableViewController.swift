//
//  SearchTableViewController.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    let manager = UsersManager()
    let userCellId = "userCell"
    var userArray = [User]()
    
    var selectedIndex = -1
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        searchBar.delegate = self
        
        title = "GitHub Users"
        
        manager.getUsers()
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
                manager.getUserProfile(forUser: user) { profile in
                    if let repoCount = profile.repoCount {
                        DispatchQueue.main.async {
                            userCell.repoCountLabel.text = String(repoCount)
                        }
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailViewController {
            if let indexPath = sender as? IndexPath {
                dest.user = manager.users[indexPath.row]
                dest.manager = manager
            }
        }
    }

}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            userArray = self.manager.users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            manager.handleUserSearch(word: searchText, completion: {
                self.userArray = self.manager.userSearchResults
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = 0 - tableView.contentOffset.y
        if delta > 140 { searchBar.resignFirstResponder() }
    }
}
