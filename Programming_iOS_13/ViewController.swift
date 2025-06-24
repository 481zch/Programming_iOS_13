//
//  ViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/24.
//

import UIKit
import SnapKit
import Then

final class ViewController: UIViewController {
    
    private let label = UILabel().then {
        $0.text = "hello world"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

