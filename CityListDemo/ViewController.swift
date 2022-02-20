//
//  ViewController.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/8.
//

import UIKit

class DemoAppViewController: UIViewController {
    
    private let coordinator = Coordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator.start(in: self)
    }
}


