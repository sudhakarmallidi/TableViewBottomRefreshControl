//
//  ViewController.swift
//  RefreshControlApp
//
//  Created by apple on 11/07/17.
//  Copyright © 2017 pipip. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MNMBottomPullToRefreshManagerClient {

    @IBOutlet var tableView: UITableView!
    
    var pullToRefreshManager:MNMBottomPullToRefreshManager?
    var reloads:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reloads = -1
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.pullToRefreshManager = MNMBottomPullToRefreshManager.init(pullToRefreshViewHeight: 60.0, tableView: tableView, withClient: self )
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func loadTable() {
        self.reloads += 1
        tableView.reloadData()
        self.pullToRefreshManager!.tableViewReloadFinished()
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        self.pullToRefreshManager?.tableViewScrolled()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        self.pullToRefreshManager?.tableViewReleased()
    }
    func bottomPull(toRefreshTriggered manager: MNMBottomPullToRefreshManager!) {
        
        self.perform(#selector(loadTable), with: nil, afterDelay: 5.0)
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + (reloads*5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Row" + String(indexPath.row)
        cell.backgroundColor = UIColor.purple
        return cell
        
    }
    
}

//extension ViewController: UITableViewDelegate {
//    
//}

