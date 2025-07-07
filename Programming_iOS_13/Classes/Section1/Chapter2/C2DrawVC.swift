//
//  C2DrawVC.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/7/7.
//

import UIKit
import SnapKit
import Then

final class C2DrawVC: ScrollControllViewController, ScrollControllProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews = createContentViews()
        super.setContentViews(contentViews: contentViews)
    }
    
    func createContentViews() -> [UIView] {
        var contentViews: [UIView] = []
        contentViews.append(createView1())
        return contentViews
    }
    
    // UIKit + draw(rect:)
    private func createView1() -> UIView {
        
        final class View1: UIView {
            override func draw(_ rect: CGRect) {
                let p = UIBezierPath(ovalIn: CGRect(100.0, 100.0))
                UIColor.blue.setFill()
                p.fill()
            }
        }
        
        return View1()
        
    }
}
