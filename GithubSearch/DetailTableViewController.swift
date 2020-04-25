//
//  DetailTableViewController.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var user: User? = nil
    var manager: UsersManager? = nil
    var listArray = [Repo]()
    
    let repoCellId = "repoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfo()
        searchBar.delegate = self
        
        guard let user = user else { return }
        if let repos = user.repos {
            listArray = repos
        } else {
            manager?.getRepos(forUser: user, completion: { repos in
                self.listArray = repos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
         
    }
    
    func setupInfo() {
        guard let user = user else { return }
        title = user.username
        profilePicImageView.setImageURL(string: user.imageURL)
        
        joinDateLabel.isHidden = true
        locationLabel.isHidden = true
        emailLabel.isHidden = true
        followersLabel.text = "-"
        followingLabel.text = "-"
        emailLabel.isHidden = true
        bioLabel.isHidden = true
        
        setLabel(self.usernameLabel, withText: user.userProfile?.name)
        setLabel(self.joinDateLabel, withText: user.userProfile?.joinDate?.toDate()?.toString())
        setLabel(self.locationLabel, withText: user.userProfile?.location)
        setLabel(self.emailLabel, withText: user.userProfile?.email)
        setLabel(self.bioLabel, withText: user.userProfile?.biography)
        
        if let followers = user.userProfile?.followers {
            self.setLabel(self.followersLabel, withText: String(followers))
        }
        
        if let following = user.userProfile?.following {
            self.setLabel(self.followingLabel, withText: String(following))
        }
        
    }
    
    func setLabel(_ label: UILabel, withText possibleText: String?) {
        if let text = possibleText {
            label.isHidden = false
            label.text = text
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: repoCellId, for: indexPath) as? RepoTableViewCell {
            let repo = listArray[indexPath.row]
            cell.repoName.text = repo.name ?? "No name repo"
            cell.starsLabel.text = String(repo.stars ?? 0)
            cell.forksLabel.text = String(repo.forks ?? 0)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let repo = user?.repos?[indexPath.row], let urlString = repo.url, let url = URL(string: urlString)  {
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension DetailTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let user = user else { return }
        guard let manager = manager else { return }
        guard let repos = user.repos else { return }
        manager.handleRepoSearch(word: searchText, forUser: user, completion: {
            self.listArray = (searchText == "") ? repos : manager.repoSearchResults
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
    }
}


