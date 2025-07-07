//
//  C2DrawArrowVC.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/7/7.
//

import UIKit
import SnapKit
import RxSwift
import Then

final class C2DrawArrowVC: ScrollControllViewController, ScrollControllProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentViews = createContentViews()
        super.setContentViews(contentViews: contentViews)
    }
    
    func createContentViews() -> [UIView] {
        var contentViews: [UIView] = []
        let view1 = createView1()
        view1.backgroundColor = .gray
        view1.isOpaque = false
        let view2 = createView2()
        view2.backgroundColor = .gray
        view2.isOpaque = false
        contentViews.append(view1)
        contentViews.append(view2)
        contentViews.append(createView3())
        contentViews.append(createView4())
        return contentViews
    }
    
    private func createView1() -> UIView {
        
        class View1: UIView {
            
            override func draw(_ rect: CGRect) {
                // use Core Graphics
                let context = UIGraphicsGetCurrentContext()!
                
//                context.setShadow(offset: CGSize(width: 7, height: 7), blur: 12)
                // rectangle
                context.move(to: CGPoint(200, 500))
                context.addLine(to: CGPoint(200, 419))
                context.setLineWidth(20)
                context.strokePath()
                // draw triangle
                context.setFillColor(UIColor.red.cgColor)
                context.move(to: CGPoint(180, 419))
                context.addLine(to: CGPoint(200, 369))
                context.addLine(to: CGPoint(220, 419))
                context.fillPath()
                // snip triangle
                context.setFillColor(UIColor.gray.cgColor)
                context.move(to: CGPoint(200, 480))
                context.addLine(to: CGPoint(190, 500))
                context.addLine(to: CGPoint(210, 500))
                // context.setBlendMode(.clear)  // 好像没有起作用
                context.fillPath()
                
                context.clear(CGRect(500, 500))
            }
        }
        
        return View1()
    }
    
    private func createView2() -> UIView {
        
        class View2: UIView {
            
            override func draw(_ rect: CGRect) {
                // use UIKit
                let pen = UIBezierPath()
                // rectangle
                pen.move(to: CGPoint(200, 500))
                pen.addLine(to: CGPoint(200, 419))
                pen.lineWidth = 20
                pen.stroke()
                // draw triangle
                UIColor.red.set()
                pen.removeAllPoints()
                pen.move(to: CGPoint(180, 419))
                pen.addLine(to: CGPoint(200, 369))
                pen.addLine(to: CGPoint(220, 419))
                pen.fill()
                // snip triangle
                pen.removeAllPoints()
                pen.move(to: CGPoint(200, 480))
                pen.addLine(to: CGPoint(190, 500))
                pen.addLine(to: CGPoint(210, 500))
                pen.fill(with: .clear, alpha: 1.0)  // 同样没有起作用

            }
        }
        
        return View2()
    }
    
    private func createView3() -> UIView {
        
        class View3: UIView {
            
            override func draw(_ rect: CGRect) {
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let locations: [CGFloat] = [0.0, 1.0]
                let compoents: [CGFloat] = [
                    220.0/255.0, 20.0/255.0, 60.0/255.0, 0.6,
                    1.0, 1.0, 1.0, 1.0
                ]
                let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: 2)!
                let context = UIGraphicsGetCurrentContext()
                context?.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: AppConstants.width, y: AppConstants.height), options: [])
            }
        }
        
        return View3()
    }
    
    private func createView4() -> UIView {
        class View4: UIView {
            override func draw(_ rect: CGRect) {
                // 1. 先用 UIGraphicsImageRenderer 离屏生成一个 4×4 的 pattern 图
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8))
                let image = renderer.image { rctx in
                    let ctx = rctx.cgContext
                    ctx.setFillColor(UIColor.blue.cgColor)
                    // 在小画布中央画一个直径 2pt 的圆
                    ctx.fillEllipse(in: CGRect(x: 1, y: 1, width: 4, height: 4))
                }

                // 2. 用这个 image 构造平铺颜色
                let patternColor = UIColor(patternImage: image)
                patternColor.setFill()

                // 3. 用一个闭合的矩形路径把整个 rect 填充为平铺图案
                let path = UIBezierPath(rect: rect)
                path.fill()
            }
        }

        // 不指定 frame 由外部布局，如果需要测试可手动指定一个大小：
        // return View4(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        return View4()
    }
}

extension CGPoint {
    init(_ x: Int, _ y: Int) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }
}
