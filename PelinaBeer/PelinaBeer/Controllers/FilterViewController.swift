//
//  FilterViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/14/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    
    override var modalPresentationStyle: UIModalPresentationStyle {get { .overFullScreen} set { self.modalPresentationStyle = newValue }}
    override var modalTransitionStyle: UIModalTransitionStyle { get {.crossDissolve} set {self.modalTransitionStyle = newValue}}
    
    fileprivate let filterOptions = ["Genres", "Year", "Rating"]
    fileprivate var isFirstAppear : Bool!
    
    let sections = ["Filter by", "Order by"]
    var filter : MovieDiscoverFilter!
    var delegate : FilterViewControllerDelegate?
    var genresVC : GenresTableViewController!
    
    init(filter: MovieDiscoverFilter) {
        super.init(nibName: nil, bundle: nil)
        self.filter = filter
        self.genresVC = GenresTableViewController()
        self.genresVC.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let applyButton : UIButton = {
        
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Close", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .mainColor
        b.layer.cornerRadius = 10
        return b
    }()
    
    let clearButton : UIButton = {
         
         let b = UIButton(type: .system)
         b.translatesAutoresizingMaskIntoConstraints = false
         b.setTitle("Clear", for: .normal)
         b.setTitleColor(.mainColor, for: .normal)
         b.layer.cornerRadius = 10
         return b
     }()
    
    let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Filtro"
        l.font = .boldSystemFont(ofSize: 28)
        l.textColor = .darkText
        return l
    }()
    
    let filterOptionstableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain   )
        t.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "optionCell")
        t.translatesAutoresizingMaskIntoConstraints = false
        t.tableFooterView = .init(frame: .zero)
        t.backgroundColor = .clear
        t.separatorStyle = .none
        return t
    }()
    
    let labelSeparator : UIView = {
        
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(labelSeparator)
        labelSeparator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        labelSeparator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(applyButton)
        view.addSubview(clearButton)
        
        applyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        view.addSubview(filterOptionstableView)
        filterOptionstableView.topAnchor.constraint(equalTo: labelSeparator.bottomAnchor).isActive = true
        filterOptionstableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        filterOptionstableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -8).isActive = true
        filterOptionstableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        isFirstAppear = true
        filterOptionstableView.delegate = self
        filterOptionstableView.dataSource = self
        
        
        applyButton.addTarget(self, action: #selector(touchCloseButton), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(touchClearButton), for: .touchUpInside)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @objc func touchCloseButton() {
        
        if let delegate = self.delegate {
            
            delegate.filterApplied(filter: filter)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func touchClearButton() {
        
        filter.genres = nil
        filter.pageNumber = 0
        filter.rating = 0
        filter.year = nil
        filter.sort_by = Sort.sorts["popularity"]
        
        self.filterOptionstableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FilterViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 1) {
            
            let vc = SortTableViewController(filter: filter)
            vc.delegate = self
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
        
        switch indexPath.row {
        case 0: self.present(UINavigationController(rootViewController: genresVC), animated: true, completion: nil)
        case 1: self.selectYear()
        case 2: self.selectRating()
        default: break
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(isFirstAppear) {
            cell.frame.origin.x += view.frame.width
            UIView.animate(withDuration: 1, delay: 0.2 * Double(indexPath.row), usingSpringWithDamping: 40, initialSpringVelocity: 15, options: [.curveEaseIn], animations: {
                cell.frame.origin.x -= self.view.frame.width
            }, completion: nil)
        }
        
        if(indexPath.section == 1) {
            
            isFirstAppear = false
        }
    }
    
    func selectYear() {
        
        let message = "\n\n\n\n\n\n"
        let alert = UIAlertController(title: "Select a year", message: message, preferredStyle: .alert)
        
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        alert.view.addSubview(picker)
        
        picker.widthAnchor.constraint(equalToConstant: view.frame.width / 2.5).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 100).isActive = true
        picker.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor).isActive = true
        picker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let selected = picker.selectedRow(inComponent: 0)
            self.filter.year = selected + 1960
            self.filterOptionstableView.reloadData()
        }))
        alert.addAction( UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectRating() {
        
        let alert = UIAlertController(title: "Ratin Greater than", message: self.filter.rating.description, preferredStyle: .alert)
        
        let stepper = UIStepper(frame: .zero)
        
        stepper.value = self.filter.rating
        
        stepper.minimumValue = 0
        stepper.stepValue = 0.5
        stepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        alert.view.addSubview(stepper)
        
        alert.view.heightAnchor.constraint(equalToConstant: 180).isActive = true
        stepper.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor).isActive = true
        stepper.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.filter.rating = stepper.value
            self.filterOptionstableView.reloadData()
        }))
        alert.addAction( UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func stepperChanged(_ sender: UIStepper) {
        
        if let alert = self.presentedViewController as? UIAlertController {
            
            alert.message = sender.value.description
        }
    }
}

extension FilterViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Calendar.current.component(.year, from: Date()) - 1959
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        (1960 + row).description
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }
}

extension FilterViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? filterOptions.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! SubtitleTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.textColor = .mainColor
        cell.backgroundColor = .clear
        cell.detailTextLabel?.numberOfLines = 0
        
        if(indexPath.section == 0) {
            
            switch indexPath.row {
                
            case 0: fillCell(cell: cell, title: filterOptions[indexPath.row], data: filter.getGenresNames())
            case 1: fillCell(cell: cell, title: filterOptions[indexPath.row], data: filter.year?.description)
            case 2: fillCell(cell: cell, title: filterOptions[indexPath.row], data: filter.rating?.description)
            default: break
            }
        } else if(indexPath.section == 1) {
            
            cell.textLabel?.text = filter.sort_by.description
        }
        
        
        return cell
    }
    
    func fillCell(cell: SubtitleTableViewCell, title: String, data: String?) {
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = data ?? "Empty"
    }
}


extension FilterViewController : GenresTableViewDelegate {
    
    func genresTableSelected(genres: [Genre]) {
        
        self.filter.genres = genres
        self.filterOptionstableView.reloadData()
    }
}


extension FilterViewController : SortTableViewDelegate {
    
    func sortChanged(sort: Sort) {
        self.filterOptionstableView.reloadData()
    }
}



protocol FilterViewControllerDelegate {
    
    func filterApplied(filter: MovieDiscoverFilter)
}

extension FilterViewControllerDelegate {
    
    func filterApplied(filter: MovieDiscoverFilter) {
        
    }
}
