//
//  TPETouristAttractionsTableViewController.swift
//  TaipeiTour
//
//  Created by Luis Wu on 11/25/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//

import UIKit

class TPETouristAttractionsTableViewController: UITableViewController {
    struct Consts {
        static let cellIdentifier = "TPETouristAttractionTableViewCell"
        static let headerIdentifier = "TPETouristAttractionTableViewHeader"
        static let estimatedRowHeight: CGFloat = 190
        static let headerHeight: CGFloat = 35
        static let sectionNumWithCategoryFilter = 1
    }
    
    var touristAttractions: [String : [TPETouristAttractionModel]]?
    var sortedSubCategoryKeys: [String]?
    var selectedCategoryIndex: Int?
    let presenter = TPETouristAttractionsPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupNavigationBar()
        setupTable()
        self.reloadAttractions(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupTable() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: Consts.headerIdentifier)
        self.tableView.estimatedRowHeight = Consts.estimatedRowHeight
        self.tableView.separatorStyle = .none
        
        // prepare empty view
        let emptyMessageLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                      width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        emptyMessageLabel.text = NSLocalizedString("no_data", comment:"")
        emptyMessageLabel.textColor = UIColor.lightGray
        emptyMessageLabel.backgroundColor = UIColor.white
        emptyMessageLabel.numberOfLines = 0;
        emptyMessageLabel.textAlignment = .center;
        emptyMessageLabel.sizeToFit()
        self.tableView.backgroundView = emptyMessageLabel;
        self.tableView.addConstraint(NSLayoutConstraint(item: self.tableView.backgroundView!,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: self.tableView,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0))
        self.tableView.addConstraint(NSLayoutConstraint(item: self.tableView.backgroundView!,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: self.tableView,
                                                        attribute: .height,
                                                        multiplier: 1.0,
                                                        constant: 0))
        
        // prepare refresh control
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = UIRefreshControl()
        } else {
            refreshControl = UIRefreshControl()
            self.tableView.addSubview(refreshControl!)
        }
        refreshControl?.addTarget(self, action: #selector(reloadAttractions(_:)), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("nav_bar_title", comment: "")
        self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("category", comment: "")
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func reloadAttractions(_ sender: AnyObject?) {
        presenter.getCategorizedTouristAttractions(success: { (response) in
            self.touristAttractions = response
            if let dictKeys = self.touristAttractions?.keys {
                self.sortedSubCategoryKeys = Array(dictKeys).sorted{ $0 > $1 }
            }
            self.tableView.reloadData()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            (sender as? UIRefreshControl)?.endRefreshing()
        }, failure: { (error) in
            let errorAlert = UIAlertController(title: NSLocalizedString("error", comment: "") , message: error.localizedDescription , preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("dismiss", comment: ""), style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
            (sender as? UIRefreshControl)?.endRefreshing()
        })
    }
    
    @IBAction func chooseSubCategory() {
        let categoryAlert = UIAlertController(title: NSLocalizedString("category", comment: ""), message: NSLocalizedString("category_filter_message", comment: ""), preferredStyle: .actionSheet)
        
        // all categories
        let allAction = UIAlertAction(title: NSLocalizedString("all_categories", comment: ""), style: .default, handler: { (action) in
            self.selectedCategoryIndex  = nil
            self.tableView.reloadData()
        })
        categoryAlert.addAction(allAction)
        
        // other categories
        if let keys = self.sortedSubCategoryKeys {
            for key in keys {
                let action = UIAlertAction(title: key, style: .default, handler: { (action) in
                    self.selectedCategoryIndex = keys.index(of: action.title!)
                    self.tableView.reloadData()
                })
                categoryAlert.addAction(action)
            }
        }
        self.present(categoryAlert, animated: true, completion:nil)
        
    }

    // MARK - UITableViewControllerDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.selectedCategoryIndex != nil {
            return Consts.sectionNumWithCategoryFilter
        }
        return self.touristAttractions == nil ? 0 : self.touristAttractions!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedCategoryIndex = self.selectedCategoryIndex {
            return self.touristAttractions![(sortedSubCategoryKeys![selectedCategoryIndex])]!.count
        }
        return self.touristAttractions == nil ? 0 : self.touristAttractions![(sortedSubCategoryKeys![section])]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.cellIdentifier, for: indexPath) as! TPETouristAttractionTableViewCell
        let section = self.selectedCategoryIndex == nil ? indexPath.section : self.selectedCategoryIndex!
        cell.updateCellBy(model: self.touristAttractions![sortedSubCategoryKeys![section]]![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Consts.headerIdentifier)
        if header == nil {
            header = UITableViewHeaderFooterView(reuseIdentifier: Consts.headerIdentifier)
        }
        header?.textLabel?.text = sortedSubCategoryKeys![self.selectedCategoryIndex == nil ? section : self.selectedCategoryIndex!]
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Consts.headerHeight
    }
    
    // MARK - UITableViewControllerDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TPETouristAttractionTableViewCell
        let section = self.selectedCategoryIndex == nil ? indexPath.section : self.selectedCategoryIndex!
        let model = self.touristAttractions![self.sortedSubCategoryKeys![section]]![indexPath.row]
        model.isExpanded = !model.isExpanded // toggle
        tableView.beginUpdates()
        cell.updateCellBy(model: model)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TPETouristAttractionTableViewCell {
            cell.onEndDisplaying()
        }
    }
}

