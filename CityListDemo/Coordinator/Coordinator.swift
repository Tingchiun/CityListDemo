//
//  Coordinator.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/8.
//

import Foundation
import UIKit

class Coordinator {

    private var currentViewController: UIViewController?
    private var navigationController: UINavigationController?

    func start(in vc: UIViewController) {
        currentViewController = vc
        presentCityList(in: vc)
    }
    
    private func presentCityList(in vc: UIViewController) {
        let rootVC = CityListViewController()
        rootVC.delegate = self
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        vc.present(navVC, animated: false)
        navigationController = navVC
    }
}

extension Coordinator: CityListViewControllerDelegate {
    func navigateToDetail(viewModel: DetailViewModel) {
        let vc = DetailViewController()
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
