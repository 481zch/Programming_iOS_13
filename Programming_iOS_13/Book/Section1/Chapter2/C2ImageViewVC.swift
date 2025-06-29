//
//  C2ImageViewVC.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/27.
//

import UIKit
import SnapKit
import Then

final class C2ImageViewVC: ScrollControllViewController, ScrollControllProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews = createContentViews()
        super.setContentViews(contentViews: contentViews)
    }
    
    func createContentViews() -> [UIView] {
        var contentViews: [UIView] = []
        contentViews.append(createView1())
//        contentViews.append(createView2())
        contentViews.append(createView3())
        contentViews.append(createView4())
        return contentViews
    }
    
    // .scaleTofill
    private func createView1() -> UIView {
        let view = UIView()
        let view_in = UIView().then {
            $0.backgroundColor = .red
        }
        let imageView = UIImageView().then {
            $0.image = UIImage(named: "earth")
            $0.contentMode = .scaleToFill
            $0.layer.masksToBounds = true
        }
        view.addSubview(view_in)
        view_in.addSubview(imageView)
        view_in.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
    
    // .center - 会超出
    private func createView2() -> UIView {
        let view = UIView()
        let view_in = UIView().then {
            $0.backgroundColor = .red
        }
        let imageView = UIImageView().then {
            $0.image = UIImage(named: "earth")
            $0.contentMode = .center
        }
        view.addSubview(view_in)
        view_in.addSubview(imageView)
        view_in.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
    
    // .scaleAspectFit
    private func createView3() -> UIView {
        let view = UIView()
        let view_in = UIView().then {
            $0.backgroundColor = .red
        }
        let imageView = UIImageView().then {
            $0.image = UIImage(named: "earth")
            $0.contentMode = .scaleAspectFit
        }
        view.addSubview(view_in)
        view_in.addSubview(imageView)
        view_in.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
    
    // .scaleAspectFill
    private func createView4() -> UIView {
        let view = UIView()
        let view_in = UIView().then {
            $0.backgroundColor = .red
        }
        let imageView = UIImageView().then {
            $0.image = UIImage(named: "earth")
            $0.contentMode = .scaleAspectFill
        }
        view.addSubview(view_in)
        view_in.addSubview(imageView)
        view_in.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
}
