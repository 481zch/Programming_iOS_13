//
//  C2AnimationViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/7/1.
//

import UIKit
//import QuartzCore

final class C2AnimationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        let subView = UIView()
        view.addSubview(subView)
        view.backgroundColor = .gray
        subView.backgroundColor = .white
        subView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }

        subView.layer.addSublayer(createCALayer2())
    }
    
    private func createCALayer1() -> CALayer {
        let blueLayer = CALayer()
        blueLayer.frame = CGRectMake(50, 50, 100, 100)
        blueLayer.backgroundColor = UIColor.blue.cgColor
        return blueLayer
    }
    
    private func createCALayer2() -> CALayer {
        let imageLayer = CALayer()
        let image = UIImage(named: "earth")
        imageLayer.contents = image?.cgImage
        imageLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageLayer.contentsScale = 1.0
//        imageLayer.contentsGravity = .center
        return imageLayer
    }
}
