//
//  C2TransparencyMaskViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/30.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class C2TransparencyMaskViewController: ScrollControllViewController, ScrollControllProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews = createContentViews()
        super.setContentViews(contentViews: contentViews)
    }
    
    func createContentViews() -> [UIView] {
        var contentViews: [UIView] = []
        contentViews.append(createView1())
        contentViews.append(createView2())
        return contentViews
    }
    
    private func createView1() -> UIView {
        let view = UIView()
        let image = UIImage(named: "earth")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image).then {
            $0.frame = CGRect(500, 500)
            $0.tintColor = .red
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(500)
            make.height.equalTo(500)
        }
        return view
    }
    
    // Template render
    // 对不透明通道全部渲染为tintColor
    private func createView2() -> UIView {
        let view = UIView()
        let image = UIImage(named: "earth")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image).then {
            $0.frame = CGRect(500, 500)
            $0.tintColor = .red
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(500)
            make.height.equalTo(500)
        }
        return view
    }
}
