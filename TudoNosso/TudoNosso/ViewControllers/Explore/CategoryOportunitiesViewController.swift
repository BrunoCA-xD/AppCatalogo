//
//  CategoryOportunitiesViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 11/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class CategoryOportunitiesViewController : UIViewController,UISearchBarDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var headerItem: UINavigationItem!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var buttonBuy: UIButton!
    
    //MARK: - ACTIONS
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMarketPlace(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("clicou")
    }
    //MARK: - PROPERTIES
    var filteredOngoingJobs : [Job] = []
    var searchController = UISearchController(searchResultsController: nil)
    var titleHeader: String = ""
    var jobsData = JobsDataSource()
    var ongoingJobs : [Job] = []
    var jobs : [Job] = [] {
        didSet {
            self.sortJobs()
        }
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        imageProduct.image = UIImage(named: titleHeader)!
        imageProduct.layer.cornerRadius = 30
        imageProduct.layer.masksToBounds = true
        
        var currentTitle = titleHeader.replacingOccurrences(of: " 1", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 2", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 3", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 4", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 0", with: "", options: .literal, range: nil)
        
        headerItem.title = currentTitle
        
        buttonBuy.layer.cornerRadius = 10
    }
    

    func sortJobs(){
        for job in jobs {
            if job.status {
                ongoingJobs.append(job)
            }
        }
    }
    
    //MARK: - SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is JobViewController {
            if let vc = segue.destination as? JobViewController,
                let selectedJob = sender as? Job {
                vc.job = selectedJob
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension CategoryOportunitiesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedJob = ongoingJobs[indexPath.row]
        self.performSegue(withIdentifier: "showDetailJobSegue", sender: selectedJob)
    }
    
}
// MARK: - UITableViewDataSource
extension CategoryOportunitiesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredOngoingJobs.count
        } else {
            return ongoingJobs.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JobsTableViewCell.reuseIdentifer, for: indexPath) as? JobsTableViewCell else {
            fatalError("The dequeued cell is not an instance of JobsTableViewCell.")
        }
        
        let jobList: Job
        
        if searchController.isActive && searchController.searchBar.text != "" {
            jobList = filteredOngoingJobs[indexPath.row]
        } else {
            jobList = ongoingJobs[indexPath.row]
        }
        
        cell.configure(job: jobList)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
}



