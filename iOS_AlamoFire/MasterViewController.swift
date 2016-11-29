//
//  MasterViewController.swift
//  iOS_AlamoFire
//
//  Created by imac on 28/11/2016.
//  Copyright © 2016 imac. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    private var _manager:Manager = Manager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _manager.getPosts(launchAfterUpdate:{self.updateDisplay()})
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewPost(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.tableView?.addSubview(refreshControl!)
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.refreshControl?.isRefreshing)! {
            _manager.clearPosts()
            _manager.getPosts(launchAfterUpdate:{self.updateDisplay()})
            self.refreshControl?.endRefreshing()
        }
    }
    
    func updateDisplay() {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewPost(_ sender: Any) {
        _manager.insertRandomPost()
        self.updateDisplay()
        self.tableView.scrollToRow(at: IndexPath(row:_manager.getLastPosts().count - 1, section:0), at: .bottom, animated: true)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let post = _manager.getLastPosts()[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = post
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _manager.getLastPosts().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let post = _manager.getLastPosts()[indexPath.row]
        cell.textLabel!.text = post.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let split = self.splitViewController {
                let controllers = split.viewControllers
                self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
                if let detailVC = self.detailViewController,
                    let detailItem = detailVC.detailItem,
                    detailItem.id == _manager.getPost(at: indexPath.row).id {
                    detailVC.detailDescriptionLabel.text = ""
                    detailVC.detailBodyTextView.text = ""
                }
            }
            _manager.removePost(at: indexPath.row)
            self.updateDisplay()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
