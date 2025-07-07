//
//  C2ResizableViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/24.
//

import UIKit
import SnapKit
import Then

/*
 放弃，复现不出书中的效果，只能在后面实战中进行摸索了
 */

final class C2ResizableViewController: ScrollControllViewController, ScrollControllProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews = createContentViews()
        super.setContentViews(contentViews: contentViews)
    }
    
    func createContentViews() -> [UIView] {
        var contentViews: [UIView] = []
        
        contentViews.append(createView1())
        contentViews.append(createView2())
        contentViews.append(createView3())
        contentViews.append(createView4())
        contentViews.append(createView5())

        return contentViews
    }
    
    private func createView1() -> UIView {
        let view = UIView()
        let image = UIImage(named: "earth")
        let imageView = UIImageView().then {
            $0.frame = CGRect(900, 300)
            $0.contentMode = .scaleToFill
            $0.image = image
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(900)
            make.height.equalTo(300)
        }
        return view
    }
    
    private func createView2() -> UIView {
        let view = UIView()
        let image = UIImage(named: "earth")
        let imageTiled = image?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        let imageView = UIImageView().then {
            $0.frame = CGRect(900, 300)
            $0.contentMode = .scaleToFill
            $0.image = imageTiled
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(900)
            make.height.equalTo(300)
        }
        return view
    }
    
    private func createView3() -> UIView {
        let view = UIView()
        let image = UIImage(named: "earth")
        let imageTiled = image?.resizableImage(
        withCapInsets: UIEdgeInsets(
            top: image!.size.height / 4,
            left: image!.size.width / 4,
            bottom: image!.size.height / 4,
            right: image!.size.width / 4),
        resizingMode: .tile)
        let imageView = UIImageView().then {
            $0.frame = CGRect(900, 300)
            $0.contentMode = .scaleToFill
            $0.image = imageTiled
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(900)
            make.height.equalTo(300)
        }
        return view
    }
    
    private func createView4() -> UIView {
        let view = UIView()
        let image = UIImage(named: "earth")
        let imageTiled = image?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        let imageView = UIImageView().then {
            $0.frame = CGRect(900, 300)
            $0.contentMode = .scaleToFill
            $0.image = imageTiled
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(900)
            make.height.equalTo(300)
        }
        return view
    }
    
    private func createView5() -> UIView {
        let view = UIView()
        let image = UIImage(named: "earth")
        let imageTiled = image?.resizableImage(withCapInsets: UIEdgeInsets(
           top: image!.size.height / 4,
           left: image!.size.width / 4,
           bottom: image!.size.height / 4,
           right: image!.size.width / 4),
        resizingMode: .stretch)
        let imageView = UIImageView().then {
            $0.frame = CGRect(900, 300)
            $0.contentMode = .scaleToFill
            $0.image = imageTiled
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(900)
            make.height.equalTo(300)
        }
        return view
    }
}

