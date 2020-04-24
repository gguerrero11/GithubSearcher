//
//  SearchTableViewController.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet var searchBar: UITableView!
    
    let manager = UsersManager()
    let userCellId = "userCell"
    
    var selectedIndex = -1
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        manager.usersDownloadCallback = {
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
        return manager.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let userCell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as? UserTableViewCell {
            let user = manager.users[indexPath.row]
            userCell.userNameLabel.text = user.username
            
            if let repoCount = user.repos?.count {
                userCell.repoCountLabel.text = String(repoCount)
            } else {
                manager.getRepos(forUser: user, completion: {
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                })
            }
        
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
        selectedIndex = indexPath.row
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if var detailView = segue.destination as? DetailTableViewController {
//            detailView.user = manager.users[selectedIndex]
//        }
        // Pass the selected object to the new view controller.
    }
    

}
