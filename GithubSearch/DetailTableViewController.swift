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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfo()

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
        
        manager?.getUserProfile(forUser: user, completion: { (userProf) in
            self.setLabel(self.usernameLabel, withText: userProf.name)
            self.setLabel(self.joinDateLabel, withText: userProf.joinDate?.toDate()?.toString())
            self.setLabel(self.locationLabel, withText: userProf.location)
            self.setLabel(self.emailLabel, withText: userProf.email)
            self.setLabel(self.bioLabel, withText: userProf.biography)
            
            if let followers = userProf.followers {
                self.setLabel(self.followersLabel, withText: String(followers))
            }
            
            if let following = userProf.following {
                self.setLabel(self.followingLabel, withText: String(following))
            }
        })
    }
    
    func setLabel(_ label: UILabel, withText possibleText: String?) {
        if let text = possibleText {
            label.isHidden = false
            label.text = text
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

