//
//  C2ImageAssetTraitCollection.swift
//  Programming_iOS_13
//
//  Created by zangconghui on 2025/6/26.
//

import UIKit
import SnapKit
import Then

// MARK: view1 和 view2 并没有达到预期效果，依旧错误，无法手动控制image asset根据自定义的TraitCollection返回对应的image，只能根据系统的进行返回
// MARK: 通过3和4自定义的方式也不能够正常显示
// 总结如下：只能注册，不能自定义获取，必须使用系统自定义的TraitCollection

final class C2ImageAssetTraitCollection: ScrollControllViewController, ScrollControllProtocol {
    
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
    
    func createView1() -> UIView {
        let view = UIView()
        let lightTrait = UITraitCollection(userInterfaceStyle: .light)
        let respondAsset = UIImage(named: "planet")?.imageAsset
        respondAsset?.register(UIImage(named: "planet")!, with: lightTrait)
        
        let lightImage = respondAsset?.image(with: lightTrait)
        let imageView = UIImageView(image: lightImage)
        let label = UILabel().then {
            $0.text = "day"
        }
        
        view.addSubview(imageView)
        view.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        return view
    }
    
    // About try to custom the map of image and traitCollection
    func createView2() -> UIView {
        let view = UIView()
        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        let respondAsset = UIImage(named: "planet")?.imageAsset
        respondAsset?.register(UIImage(named: "planet")!, with: darkTrait)

        let darkImage = respondAsset?.image(with: darkTrait)
        let imageView = UIImageView(image: darkImage)
        let label = UILabel().then {
            $0.text = "night"
        }
        
        view.addSubview(imageView)
        view.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        return view
    }
    
    func createView3() -> UIView {
        let view = UIView()
        
        // MARK: 是的，强引用，系统会自动缓存
        let customAsset = UIImageAsset()
        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        let lightTrait = UITraitCollection(userInterfaceStyle: .light)
        
        customAsset.register(UIImage(contentsOfFile: Bundle.main.path(forResource: "moon", ofType: "png")!)!, with: darkTrait)
        customAsset.register(UIImage(contentsOfFile: Bundle.main.path(forResource: "sun", ofType: "png")!)!, with: lightTrait)
        
        // MARK: 经过测试发现，这个不认可自定义的traitCollection，必须是系统默认的
        let image = customAsset.image(with: darkTrait)
        let imageView = UIImageView(image: image)
        let label = UILabel().then {
            $0.text = "moon"
        }
        
        view.addSubview(imageView)
        view.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        return view
    }
    
    // About register traitCollection for case that image from internet
    func createView4() -> UIView {
        let view = UIView()
        
        let customAsset = UIImageAsset()
        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        customAsset.register(UIImage(contentsOfFile: Bundle.main.path(forResource: "moon", ofType: "png")!)!, with: darkTrait)
        
        let image = customAsset.image(with: darkTrait)
        let imageView = UIImageView(image: image)
        let label = UILabel().then {
            $0.text = "moon"
        }
        
        view.addSubview(imageView)
        view.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        return view
    }
    
    // About of dynamic color
    func createView5() -> UIView {
        let view = UIView()
        let dynamicColor = UIColor(dynamicProvider: { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .red
            } else {
                return .green
            }
        })
        
        let color = dynamicColor.resolvedColor(with: self.traitCollection)
        let label_0 = UILabel().then {
            $0.backgroundColor = color
        }
        let label_1 = UILabel().then {
            $0.text = "dynamic color"
        }
        
        view.addSubview(label_0)
        view.addSubview(label_1)
        label_0.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        label_1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label_0.snp.bottom).offset(20)
        }
        
        return view
    }
}
