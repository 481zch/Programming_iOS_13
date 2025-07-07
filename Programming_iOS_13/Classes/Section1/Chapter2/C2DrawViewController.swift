//
//  C2DrawViewController.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/7/1.
//

import UIKit

final class C2DrawViewController: ScrollControllViewController, ScrollControllProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews = createContentViews()
        super.setContentViews(contentViews: contentViews)
    }
    
    func createContentViews() -> [UIView] {
        var contentViews: [UIView] = []
        contentViews.append(SubView1())
        contentViews.append(SubView2())
        contentViews.append(SubView3())
        contentViews.append(SubView4())
        return contentViews
    }
}

final class SubView1: UIView {
    
    // UIKit
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: CGRect(100, 100))
        // 设置系统预定义颜色
        UIColor.blue.setFill()
        p.fill()
    }
}

final class SubView2: UIView {
    // Core Graphics
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: CGRect(100, 100))
        context?.setFillColor(UIColor.blue.cgColor)
        context?.fillPath()
    }
}

final class SubView3: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.delegate = self
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CALayer's delegate
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        let p = UIBezierPath(ovalIn: CGRect(100, 100))
        UIColor.blue.setFill()
        p.fill()
        UIGraphicsPopContext()
    }
}

final class SubView4: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 使用UIGraphicsImageRenderer绘制image
    private func setupSubviews() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let image = render.image(actions: { ctx in
            let p = UIBezierPath(ovalIn: CGRect(100, 100))
            UIColor.blue.setFill()
            p.fill()
        })
        let imageView = UIImageView(image: image)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
