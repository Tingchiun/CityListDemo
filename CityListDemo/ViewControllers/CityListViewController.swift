//
//  CityListViewController.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/8.
//

import UIKit
import Combine

protocol CityListViewControllerDelegate {
    func navigateToDetail(viewModel: DetailViewModel)
}

class CityListViewController: UIViewController {

    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView()

    private let viewModel = CityListViewModel()
    private var listItemCellModelsDic: [Int: [ListItemCellModel]] = [:]
    private var cancellableLists: [AnyCancellable] = []
    var delegate: CityListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        tableView.delegate = self
        tableView.dataSource = self
        viewModel.cellsInfo.forEach { cellInfo in
            tableView.register(UINib(nibName: cellInfo.nibName, bundle: nil), forCellReuseIdentifier: cellInfo.identifier)
        }
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear

        NSLayoutConstraint.activate ([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        dataBinding()
    }

    @objc func refreshData() {
        viewModel.fetchAll()
    }
    
    private func dataBinding() {
        viewModel.fetchAll()
        for index in 0..<viewModel.cellModelPublishers.count {
            let cancellable = viewModel
                .cellModelPublishers[index]
                .receive(on: DispatchQueue.main)
                .sink { cellModels in
                    self.listItemCellModelsDic[index] = cellModels.sorted { $0.cellName < $1.cellName }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            cancellableLists.append(cancellable)
        }
    }
}

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellIdentifier = viewModel.getSectionCellIndentifier(index: indexPath.section),
              let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier),
              let cellModels = listItemCellModelsDic[indexPath.section],
              indexPath.row < cellModels.count else {
                  return UITableViewCell()
              }
        viewModel.update(cell, with: cellModels[indexPath.row], index: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getSectionTitle(index: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfItemsInSection = listItemCellModelsDic[section]?.count else {
            return 0
        }
        return numberOfItemsInSection
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else if indexPath.section == 1 {
            return 80
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 10
    }
}

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = (listItemCellModelsDic[indexPath.section])?[indexPath.row] else {
            return
        }
        self.delegate?.navigateToDetail(viewModel: cellViewModel.convertToDetailViewModel())
    }
    
    private func navigateToDetail(viewModel: DetailViewModel) {
        delegate?.navigateToDetail(viewModel: viewModel)
    }
}

