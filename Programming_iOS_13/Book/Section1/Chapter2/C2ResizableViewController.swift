//
//  C2ResizableViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/24.
//

import UIKit
import SnapKit
import Then

final class C2ResizableViewController: ScrollControllViewController, ScrollControllProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews = createContentViews()
        super.setContentViews(contentViews: contentViews)
    }
    
    internal func createContentViews() -> [UIView] {
        var views: [UIView] = []
        
        let view1 = UIView(frame: CGRect())
        let image1 = UIImage(named: "rainbow")!
        let imageView1 = UIImageView().then {
            $0.contentMode = .scaleToFill
            $0.image = image1.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        }
        view1.addSubview(imageView1)
        imageView1.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(100)
            make.bottom.right.equalToSuperview().inset(100)
        }
        views.append(view1)
        
        let view2 = UIView(frame: CGRect())
        let image2 = UIImage(named: "rainbow")!
        let imageView2 = UIImageView().then {
            $0.image = image2.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        }
        view2.addSubview(imageView2)
        imageView2.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(100)
            make.bottom.right.equalToSuperview().inset(100)
        }
        views.append(view2)
        
        let view3 = UIView(frame: CGRect())
        let image3 = UIImage(#imageLiteral(resourceName: "earth.jpg"))
        let imageView3 = UIImageView().then {
            $0.image = image3
        }
        view3.addSubview(imageView3)
        imageView3.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(100)
            make.bottom.right.equalToSuperview().inset(100)
        }
        views.append(view3)
        
        return views
    }
}
