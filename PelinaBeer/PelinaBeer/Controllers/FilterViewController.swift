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
    
    fileprivate let filterOptions = ["Categoría", "Rating"]
    fileprivate var isFirstAppear : Bool!
    
    let effectBackground: UIVisualEffectView = {
        let e = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: e)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
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
        let t = UITableView(frame: .zero, style: .plain)
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
        
        // Do any additional setup after loading the view.
        view.addSubview(effectBackground)
        effectBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        effectBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        effectBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        effectBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(labelSeparator)
        labelSeparator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        labelSeparator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(filterOptionstableView)
        filterOptionstableView.topAnchor.constraint(equalTo: labelSeparator.bottomAnchor).isActive = true
        filterOptionstableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        filterOptionstableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        filterOptionstableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        isFirstAppear = true
        filterOptionstableView.delegate = self
        filterOptionstableView.dataSource = self
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(isFirstAppear) {
            cell.frame.origin.x += view.frame.width
            UIView.animate(withDuration: 1, delay: 0.2 * Double(indexPath.row), usingSpringWithDamping: 40, initialSpringVelocity: 15, options: [.curveEaseIn], animations: {
                cell.frame.origin.x -= self.view.frame.width
            }, completion: nil)
        }
        
        if(indexPath.row == filterOptions.count - 1) {
            
            isFirstAppear = false
        }
    }
}

extension FilterViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = filterOptions[indexPath.row]
        cell.detailTextLabel?.text = "Ninguno"
        cell.detailTextLabel?.textColor = .mainColor
        cell.backgroundColor = .clear
        return cell
    }
}
