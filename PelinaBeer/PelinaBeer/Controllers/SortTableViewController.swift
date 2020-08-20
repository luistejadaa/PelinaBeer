//
//  SortTableViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/19/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class SortTableViewController: UITableViewController {

    var delegate : SortTableViewDelegate?
    var filter : MovieDiscoverFilter!
    
    init(filter: MovieDiscoverFilter) {
        super.init(style: .plain)
        self.filter = filter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sort by"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sortCell")
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let i = Sort.sorts.firstIndex {$0.value.description == filter.sort_by.description}
        let pos = Sort.sorts.distance(from: Sort.sorts.startIndex, to: i!)
        tableView.selectRow(at: IndexPath(row: pos, section: 0), animated: true, scrollPosition: .none)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Sort.sorts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath)

        cell.textLabel?.text = Array(Sort.sorts)[indexPath.row].value.description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let v = Array(Sort.sorts)[indexPath.row].value
        filter.sort_by = v
        delegate?.sortChanged(sort: v)
        self.dismiss(animated: true, completion: nil)
    }

}

protocol SortTableViewDelegate {
    func sortChanged(sort: Sort)
}

extension SortTableViewDelegate {
    
    func sortChanged(sort: Sort) {
        
    }
}
