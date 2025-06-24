//
//  TestScrollControllVC.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/24.
//

import UIKit
import SnapKit
import Then

final class TestScrollControllVC: ScrollControllViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews: [UIView] = {
            let colors: [UIColor] = [
                .red.withAlphaComponent(0.5),
                .yellow.withAlphaComponent(0.5),
                .blue.withAlphaComponent(0.5),
                .green.withAlphaComponent(0.5)
            ]
            
            return colors.map { color in
                UIView(frame: CGRect(x: 0, y: 0, width: AppConstants.width, height: AppConstants.height)).then {
                    $0.backgroundColor = color
                }
            }
        }()
        super.setContentViews(contentViews: contentViews)
    }
}
