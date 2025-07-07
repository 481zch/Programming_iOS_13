//
//  C2ImageViewViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/24.
//

import UIKit
import Then
import SnapKit

final class C2ImageViewViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
    }
    private lazy var pageControll = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = self.modes.count
    }
    private let image = UIImage(named: "earth")
    
    private let modes: [UIView.ContentMode] = [
        .scaleToFill,
        .scaleAspectFit,
        .scaleAspectFill,
        .center
    ]
    private let modeNames = ["scaleToFill", "scaleAspectFit", "scaleAspectFill", "center"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        view.addSubview(pageControll)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageControll.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(40)
        }
        setupImages()
    }
    
    private func setupImages() {
        var previousView: UIView? = nil
        for (index, mode) in modes.enumerated() {
            let contentView = UIView().then {
                $0.backgroundColor = .gray.withAlphaComponent(0.5)
                scrollView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.height.width.equalToSuperview()
                    if let previousView {
                        make.left.equalTo(previousView.snp.right)
                    } else {
                        make.left.equalToSuperview()
                    }
                }
            }
            
            // MARK: 重点就是看这四种模式的差别
            let imageView = UIImageView(image: image).then {
                $0.contentMode = mode
                $0.clipsToBounds = true
            }
            let label = UILabel().then {
                $0.text = modeNames[index]
                $0.textAlignment = .center
            }
            
            contentView.addSubview(imageView)
            contentView.addSubview(label)
            
            imageView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview().inset(20)
                make.bottom.equalTo(label.snp.top).offset(-20)
            }
            label.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview().inset(20)
                make.height.equalTo(40)
            }
            
            previousView = contentView
        }
        
        if let previousView {
            previousView.snp.makeConstraints { make in
                make.right.equalToSuperview()
            }
        }
    }
}

extension C2ImageViewViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControll.currentPage = currentPage
    }
}
