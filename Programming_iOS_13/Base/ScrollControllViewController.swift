//
//  ScrollControllViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/24.
//

// ScrollView + PageControll

import UIKit
import SnapKit
import Then

public class ScrollControllViewController: UIViewController{
    
    private var contentViews: [UIView] = []
    private let width = AppConstants.width
    private let height = AppConstants.height
    private lazy var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width * CGFloat(contentViews.count), height: height)).then {
        $0.delegate = self
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    private lazy var pageControll = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = contentViews.count
    }
    
    public func setContentViews(contentViews: [UIView]) {
        self.contentViews = contentViews
        setupSubviews()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white.withAlphaComponent(0.7)
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
        setupContentViews()
    }
    
    private func setupContentViews() {
        for (index, view) in contentViews.enumerated() {
            scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.height.equalToSuperview()
                if index == 0 {
                    make.left.equalToSuperview()
                } else {
                    make.left.equalTo(contentViews[index - 1].snp.right)
                }
            }
        }
        if let lastView = contentViews.last {
            lastView.snp.makeConstraints { make in
                make.right.equalTo(scrollView.snp.right)
            }
        }
    }
}

extension ScrollControllViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControll.currentPage = currentPage
    }
}

protocol ScrollControllProtocol {
    func createContentViews() -> [UIView]
}
