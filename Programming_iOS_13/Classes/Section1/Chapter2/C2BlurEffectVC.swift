//
//  C2BlurEffectVC.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/7/7.
//

import UIKit
import SnapKit
import RxSwift
import Then

final class C2BlurEffectVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
//        view.backgroundColor = .white
        
        // 背景图
        let backgroundIV = UIImageView(image: UIImage(named: "background"))
        backgroundIV.contentMode = .scaleAspectFill
        view.addSubview(backgroundIV)
        backgroundIV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 1. UIBlurEffect + UIVisualEffectView
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 2. UIVibrancyEffect + 子视图
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .label)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.contentView.addSubview(vibrancyView)
        vibrancyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 3. 在 vibrancyView.contentView 上添加 label，并设置内边距
        let label = UILabel().then {
            $0.text = "hello world"
            $0.textAlignment = .center
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 18, weight: .medium)
        }
        vibrancyView.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        // 可以设置只更新局部区域
//        view.setNeedsDisplay(CGRect(100, 100))
    }
}
