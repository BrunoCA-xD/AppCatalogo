//
//  ExploreViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 04/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage

class ExploreViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var jobsTableView: UITableView!
    
    @IBAction func Pedir(_ sender: Any) {
        showMenu()
    }
    
    func showMenu() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let ResetGame = UIAlertAction(title: "Ligar", style: .default, handler: { (action) -> Void in
            print("reiniciar")
        })
        
        let GoOrdemDasCartas = UIAlertAction(title: "Whatsapp", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "CardsSeg", sender: nil)
        })
        
        let EditAction = UIAlertAction(title: "Facebook", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "optionsSeg", sender: nil)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        optionMenu.addAction(ResetGame)
        optionMenu.addAction(GoOrdemDasCartas)
        optionMenu.addAction(EditAction)
        optionMenu.addAction(cancelAction)
        
        optionMenu.modalPresentationStyle = .popover
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 1.2, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: - PROPERTIES
    var selectedCause: String = ""
    var selectedOrganization: String = ""
    var selectedJob: Int = 0
    var organizationsList : [Organization] = []
    var filteredOrganizationsList : [Organization] = []
    var filteredOngoingJobs : [Job] = []
    let categories = ["Bebidas", "Refeições", "Promoções"]
    var searchController = UISearchController(searchResultsController: nil)
    var organization : Organization = Organization(name: "", address: CLLocationCoordinate2D(), email: "")
    var jobs : [Job] = []
    var backgroundQueue: OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }
    
    //MARK: IBAction
    @IBAction func actionButtonLogin(_ sender: Any) {
        if let kind = Local.userKind{
            if(kind == LoginKinds.ONG.rawValue) {
                self.performSegue(withIdentifier: "ShowAddJob", sender: self)
            }
        } else {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar(searchBarDelegate: self, searchResultsUpdating: self, jobsTableView, searchController)
        setupJobsTableView()
        setupNavegationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
        
        // remove border from nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    //MARK: setups
    func setupNavegationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xB13424, a: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xB13424, a: 1)
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFFFFFF, a: 1)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupJobsTableView() {
        jobsTableView.isHidden = false
        jobsTableView.backgroundColor = .clear
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        
        jobsTableView.register(JobsTableViewCell.nib, forCellReuseIdentifier: JobsTableViewCell.reuseIdentifer)
        jobsTableView.register(JobsTableViewHeader.nib, forHeaderFooterViewReuseIdentifier: JobsTableViewHeader.reuseIdentifer)
    }
    
    func setupTableView(){
        jobsTableView.backgroundColor = .clear
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
    }
    
    //MARK: - FILTER
    private func filterJobs(for searchText: String) {
        filteredOngoingJobs = jobs.filter { player in
            return player.title.lowercased().contains(searchText.lowercased())
        }
//        jobsTableView.reloadData()
    }
    
    private func filterOrganizations(for searchText: String) {
        filteredOrganizationsList = organizationsList.filter { player in
            return player.name.lowercased().contains(searchText.lowercased())
        }
//        jobsTableView.reloadData()
    }
    
    //MARK: LOADER
    func loadData() {
        let jobDM = JobDM()
        jobDM.find(inField: .status, withValueEqual: true, completion: { (result, error) in
            guard let result = result else { return }
            self.jobs = result
//            self.jobsTableView.reloadData()
        })
        
    }
    
    //MARK: - SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CategoryOportunitiesViewController {
            let vc = segue.destination as? CategoryOportunitiesViewController
            vc?.titleHeader = selectedCause
        } else if segue.destination is JobViewController {
            if let vc = segue.destination as? JobViewController,
                let selectedJob = sender as? Job {
                vc.job = selectedJob
            }
        } else if segue.destination is ProfileViewController {
            if let vc = segue.destination as? ProfileViewController{
                vc.email = selectedOrganization
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension ExploreViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterJobs(for: searchController.searchBar.text ?? "")
        filterOrganizations(for: searchController.searchBar.text ?? "")
    }
    
    func isSearchControllerActiveAndNotEmpty() -> Bool {
        return (searchController.isActive && searchController.searchBar.text != "")
    }
}

// MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //focus in
        isDarkStatusBar = true
    }
}

// MARK: - UITableViewDelegate
extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
        let selectedJob = jobs[indexPath.row]
        self.performSegue(withIdentifier: "showDetailSegue", sender: selectedJob)
    }
}

// MARK: - UITableViewDataSource
extension ExploreViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        
        if (section == 0) {
            myLabel.frame = CGRect(x: 10, y: 20, width: 320, height: 40)
            myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
            
        } else if (section == 1) {
            myLabel.frame = CGRect(x: 10, y: 0, width: 320, height: 40)
            myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        } else {
            myLabel.frame = CGRect(x: 10, y: -5, width: 320, height: 40)
            myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        }

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchControllerActiveAndNotEmpty() {
            return filteredOngoingJobs.count
        }
        if section < 2 {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearchControllerActiveAndNotEmpty() {
            return categories[2]
        }
        return categories[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchControllerActiveAndNotEmpty() {
            return 1
        }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var typeCell = indexPath.section
        
        if isSearchControllerActiveAndNotEmpty() {
            typeCell = 2
        }
        
        switch typeCell {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier:  "cell") as! CategoryCollectionView
            cell.tag = 0
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier:  "cell2") as! CategoryCollectionView
            cell.tag = 1
            cell.delegate = self
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier:  "cell3")!
            
            let viewDemo = UIView()
            viewDemo.frame = CGRect(x: 10, y: 10, width: cell.frame.width - 20, height: cell.frame.height - 20)
//            viewDemo.layer.shadowOpacity = 0.5
//            viewDemo.layer.shadowRadius = 5
//            viewDemo.layer.shadowOffset = CGSize.zero
            viewDemo.layer.cornerRadius = 20
            
            let imageName = "feed\(indexPath.row)"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)

            imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width - 20, height: cell.frame.height - 20)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            
            viewDemo.addSubview(imageView)
            
            cell.addSubview(viewDemo)

            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - CategoryCollectionViewDelegate
extension ExploreViewController: CategoryCollectionViewDelegate {
    func causeSelected(_ view: CategoryCollectionView, causeTitle: String?, OrganizationEmail: String?,tagCollection: Int) {
        
        if(tagCollection == 0) {
            if let title = causeTitle {
                self.selectedCause = title
            }
            self.performSegue(withIdentifier: "showCauses", sender: self)
        } else {
            if let title = OrganizationEmail {
                self.selectedOrganization = title
            }
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }
    }
}

class CustomCell: UITableViewCell {

    weak var coverView: UIImageView!
    weak var titleLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    func initialize() {
        let coverView = UIImageView(frame: .zero)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(coverView)
        self.coverView = coverView

        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel

        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.coverView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.coverView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.coverView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.coverView.trailingAnchor),

            self.contentView.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
        ])

        self.titleLabel.font = UIFont.systemFont(ofSize: 64)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.coverView.image = nil
    }
}
