//
//  FilterViewController.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func changeFilter(type: Filter)
}

class FilterViewController: UIViewController {

    private var viewModel: FilterViewModelType!
    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: FilterViewControllerDelegate?
    
    static func load(with viewModel: FilterViewModelType) -> Self
    {
        let ep = self.loadFromStoryboard()
        ep.viewModel = viewModel
        return ep
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: FilterTableViewCell.className, bundle: nil), forCellReuseIdentifier: FilterTableViewCell.reuseIdentifier)
    }

}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.reuseIdentifier, for: indexPath) as? FilterTableViewCell{
            let item = viewModel.outputs.itemAt(index: indexPath)
            cell.delegate = self
            cell.fill(with: Filter(rawValue: indexPath.row) ?? Filter.topRated, title: item)
            return cell
        }
        return UITableViewCell()
    }
}

extension FilterViewController: FilterTableViewCellDelegate{
    func buttonSelected(type: Filter) {
        delegate?.changeFilter(type: type)
    }
}
