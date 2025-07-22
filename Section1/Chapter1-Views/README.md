# Views
视图（即类为`UIView`或其子类的对象）能够在界面的矩形区域内自行绘制内容。应用之所以有可见界面，全都要归功于视图；用户所见的一切最终都源于某个视图。创建和配置一个视图可以非常简单：“设置一次，忘掉它”。你可以在 nib 编辑器中配置一个`UIButton`，运行时按钮就会如期出现并正常工作。但你也可以在运行时以更强大的方式操作视图：你的代码既可以负责视图自身部分或全部的绘制（第 2 章），也可以让视图出现或消失、移动、改变大小，甚至表现出其他各种可视化变化，可能还会带动画效果（第 4 章）。

视图也是一个响应者（`UIView` 是 `UIResponder` 的子类），这意味着视图可以响应用户的交互操作，比如轻点和滑动。视图不仅构成了用户所见的界面，也是用户触摸界面的基础（详见第 5 章）。通过合理组织视图层次，让恰当的视图处理相应的触摸事件，能够让你的代码结构清晰且高效。

视图层级是视图组织的主要形式。一个视图（`UIView`）可以拥有子视图；而子视图只有一个直接的父视图。我们可以把它看作一棵视图树。这种层级结构让视图的增删、隐藏与移动都成为成组操作：当视图被从界面移除时，其子视图也会被移除；当视图被隐藏时，其子视图也随之隐藏；当视图移动时，其子视图会一起移动；其他对视图的更改也会同步作用于其子视图。视图层级也是响应者链（`UIResponder` 链）的基础，尽管两者并不完全相同。

视图可以从 nib 文件中加载，也可以通过代码创建。总体而言，这两种方式各有利弊；具体使用哪一种，应取决于你的需求、个人偏好以及应用的整体架构。

## Window and Root View
视图层级的顶端是一个窗口。它是 `UIWindow` 的实例（或者你自定义的子类），而 `UIWindow` 又是 `UIView` 的子类。在应用启动时，系统会创建并显示这个窗口，否则屏幕将显示为黑色。在 iOS 13 中，iPad 应用可以支持多个窗口（详见第 9 章）；如果不支持或在 iPhone 上运行，应用则只有一个窗口（主窗口）。可见窗口既是所有其他可见视图的背景，也是它们的最终父视图。反过来，所有可见视图之所以能够显示，都是因为它们在某个层级深度上成为了可见窗口的子视图。

在 Cocoa 编程中，你不会手动或直接将子视图添加到窗口上。相反，窗口与其所包含界面之间的关联是通过窗口的根视图控制器来实现的。系统会实例化一个视图控制器，并将该实例赋值给窗口的 `rootViewController` 属性。此后，该视图控制器的主视图 —— 即其 `view` —— 会占据整个窗口，成为窗口的唯一子视图；所有其他可见视图都以某种层级深度成为该根视图控制器视图的子视图。（根视图控制器本身也是视图控制器层级的顶端，关于这一点我将在第 6 章详细讲解。）

### How an App Launches
你的应用在启动时，究竟是怎样获得窗口的？又是如何将窗口内容填充并显示出来的？如果你的应用使用了主 storyboard，这一切看似都是自动完成的。但“自动”并不等同于“神奇”——应用启动过程其实很简单、可预测，而且你的代码也可以参与其中。了解应用的启动流程非常有用，这样当你配置出错导致应用无法正常启动时，才能找到问题所在。

你的应用在最终层面上是通过对 `UIApplicationMain` 函数的一次调用来启动的。（与 Objective-C 项目不同，典型的 Swift 项目不会在代码中显式地调用这个函数；它会在幕后自动完成。）这次调用会创建应用启动时一些最重要的实例；如果你的应用使用了主 storyboard，那么这些实例就包括窗口以及它的 `rootViewController`。

`UIApplicationMain` 的具体执行流程取决于它在启动过程中检测到的配置。在 iOS 13 中，引入了场景机制，你的应用可以使用与场景相关的类和协议，如 `UISceneSession`、`UIScene`、`UIWindowScene` 和 `UIWindowSceneDelegate`。运行时会根据 `Info.plist` 中是否包含 “Application Scene Manifest” 字典来判断应用是否启用场景。默认情况下，通过 Xcode 内置模板创建的新项目都会包含该字典并使用场景（即便在 iPad 上并未开启多窗口功能）。不过，你也可能有旧项目，或者希望兼容 iOS 12 及更早版本。因此，接下来我会分别演示两种不同的启动流程：在 iOS 12 及之前的系统中会发生什么，以及在支持窗口场景的 iOS 13 应用中又会如何启动。

#### iOS 12 and before
下面是 `UIApplicationMain` 在 iOS 12 及更早系统上启动应用时的引导流程：
1. `UIApplicationMain` 会先实例化一个 `UIApplication` 对象并持有它，作为共享的应用实例，你的代码以后可以通过 `UIApplication.shared` 来访问。接着，它会实例化应用委托类（App Delegate），之所以能知道具体哪个类，是因为该类被标记了 `@UIApplicationMain`。然后它会持有这个应用委托实例，确保它在整个应用生命周期中都不会被释放，并将其赋值给应用实例的 `delegate` 属性。
2. `UIApplicationMain` 会检查你的应用是否使用主 storyboard；它通过读取 `Info.plist` 中名为 `Main storyboard file base name` 的条目（键名为 `UIMainStoryboardFile`），来确定是否使用主 storyboard 以及该 storyboard 的名称。如果使用，它就会实例化该 storyboard 的初始视图控制器。第 6 章中会对这部分内容进行详细讲解。
3. 如果你的应用使用了主 storyboard，那么 `UIApplicationMain` 会实例化一个 `UIWindow` 对象，并将该窗口赋值给 App Delegate 的 `window` 属性；该属性会持有对窗口的引用，从而确保窗口在应用的整个生命周期内一直存在。
4. 如果你的应用使用主 storyboard，`UIApplicationMain` 会将初始视图控制器的实例赋给窗口的 `rootViewController` 属性，并由该属性持有该实例。随后，这个视图控制器的 `view` 会成为 `UIWindow` 的唯一子视图。
5. `UIApplicationMain` 会调用应用委托的 `application(_:didFinishLaunchingWithOptions:)` 方法。
6. 应用的界面在其所在的窗口被设为关键窗口之前都是不可见的。因此，如果应用使用了主 storyboard，`UIApplicationMain` 会调用该窗口的实例方法 `makeKeyAndVisible`。

#### iOS 13 with window scene support
1. 下面是在 iOS 13 中，支持窗口场景时，`UIApplicationMain` 启动应用的引导流程：
`UIApplicationMain` 会实例化一个 `UIApplication` 对象并持有该实例，作为共享的应用实例，你的代码可以通过 `UIApplication.shared` 来访问它。接着，它会实例化应用委托类；之所以能确定具体哪个类，是因为该类被标记了 `@UIApplicationMain`。然后，它会持有该应用委托实例，保证在应用整个生命周期内都不会被释放，并将其赋值给应用实例的 `delegate` 属性。
2. `UIApplicationMain` 会调用应用委托的 `application(_:didFinishLaunchingWithOptions:)`。
3. `UIApplicationMain` 会创建一个 `UISceneSession`、一个 `UIWindowScene`，以及一个用作该 window scene 委托的实例。
在 `Info.plist` 的 `Application Scene Manifest` 字典下的 `Scene Configuration` 中，有一个名为 `Delegate Class Name` 的键，其字符串值用于指定 window scene 委托实例的类名。在 Xcode 内置的应用模板中，这通常是 `SceneDelegate` 类；考虑到 Swift 的名称修饰（name mangling），在 `Info.plist` 中一般写为 `$(PRODUCT_MODULE_NAME).SceneDelegate`。  
在 iOS 13 中，`UIApplicationMain` 会始终创建 `UISceneSession` 和 `UIWindowScene`，即便你的应用没有声明支持窗口场景——实际上，即使你的应用链接的是 iOS 12 或更早版本，这些对象也会作为架构的一部分存在，即便你的应用从未需要去引用它们。
4. 当 `UIApplicationMain` 启动时，它会检查你的初始场景是否使用了 storyboard。`Info.plist` 中 “Application Scene Manifest” 字典下的 “Scene Configuration” 部分，通过 “Storyboard Name” 键以字符串形式指定了该场景对应的 storyboard 名称。如果找到了这个键，它就会实例化该 storyboard 的初始视图控制器。
5. 如果该场景使用了 storyboard，`UIApplicationMain` 会实例化一个 `UIWindow`，并将此窗口实例赋给场景委托的 `window` 属性，该属性会保留对它的引用。
6. 如果该场景使用了 storyboard，`UIApplicationMain` 会将初始视图控制器实例赋给窗口实例的 `rootViewController` 属性，并由该属性持有该实例。随后，这个视图控制器的 `view` 会成为窗口的唯一子视图。
7. `UIApplicationMain` 会通过调用 `UIWindow` 实例的 `makeKeyAndVisible` 方法，使你的应用界面显示出来。
8. 接着会调用场景委托的 `scene(_:willConnectTo:options:)` 方法。

与 iOS 12 及之前的流程相比，这个过程最重要的区别是：
* 调用 `application(_:didFinishLaunchingWithOptions:)` 的时机要早得多。如果你仅在该方法中做一些影响整个应用的初始化，这个差异不会产生影响。但如果你需要知道启动流程何时结束并且窗口何时可见，就应在场景委托中实现 `scene(_:willConnectTo:options:)`。
* `window` 属性属于场景委托（`SceneDelegate`），而不属于应用委托（`AppDelegate`）。

### App Without a Storyboard
完全可以编写一个不使用main storyboard 的应用：
* 在 iOS 12 及更早版本中，这意味着 Info.plist 中没有 “Main storyboard file base name” 这一条目。
* 在支持场景的 iOS 13 中，这意味着在 Info.plist 的 “Application Scene Manifest” 字典里，“Application Scene Configuration” 项下没有 “Storyboard Name” 条目。

这样的应用完全通过代码来完成在使用主 storyboard 时由 `UIApplicationMain` 自动执行的所有操作。在 iOS 12 及更早版本，你需要在应用委托的 `application(_:didFinishLaunchingWithOptions:)` 方法中处理这些逻辑；而在支持窗口场景的 iOS 13 中，这部分工作则应放在场景委托的 `scene(_:willConnectTo:options:)` 方法里完成:  
```swift
func scene(_ scene: UIScene,
           willConnectTo session: UISceneSession,
           options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
        self.window = UIWindow(windowScene: windowScene)// ①
        let vc = // ...②
        self.window!.rootViewController = vc// ③
        self.window!.makeKeyAndVisible()// ④
    }
}
```
① 实例化一个 `UIWindow`，并将其赋给场景委托的 `window` 属性。务必要通过调用 `init(windowScene:)` 方法，将窗口场景与窗口正确关联起来。    
② 实例化一个视图控制器，并根据需要进行配置。  
③ 将该视图控制器赋值给窗口的 `rootViewController` 属性。  
④ 在窗口上调用 `makeKeyAndVisible()` 方法，将其显示出来。  

这就是 SwiftUI 应用的工作方式。SwiftUI 不使用 storyboard；在第二步，会创建一个 `UIHostingController` 来承载应用的初始 `View`，之后就由 SwiftUI 的代码接管。

有时候也会用到这样一种变体：虽然应用包含 storyboard，但在启动时不让 `UIApplicationMain` 自动加载它。这样一来，就可以在启动阶段根据需要决定，从该 storyboard 中哪个视图控制器作为窗口的根视图控制器。一个典型的场景是：如果用户尚未登录，应用启动时显示登录或注册界面；一旦用户完成登录，后续启动时就不再显示该界面。
```swift
func scene(_ scene: UIScene,
           willConnectTo session: UISceneSession,
           options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
        self.window = UIWindow(windowScene: windowScene)
        let userHasLoggedIn: Bool = // ...
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: userHasLoggedIn ?
                "UserHasLoggedIn" : "LoginScreen") // *
        self.window!.rootViewController = vc
        self.window!.makeKeyAndVisible()
    }
}
```

### Referring to the Window
应用运行后，你的代码可以通过多种方式引用 `UIWindow`：

From a view  
如果一个 `UIView` 已经在界面中，它会自动通过自身的 `window` 属性获取到承载它的 `UIWindow`。你的代码通常运行在一个拥有主视图的视图控制器中，因此使用 `self.view.window` 来引用窗口通常是最合适的方式。  

你也可以通过 `UIView` 的 `window` 属性来判断它是否已经嵌入到窗口中；如果没有嵌入，则该属性为 `nil`。当一个视图的 `window` 属性为 `nil` 时，它就无法出现在屏幕上。 

From the scene delegate  
场景委托实例会通过它的 `window` 属性来维护对窗口的引用。

From the application  
共享的`UIApplication.shared`通过其`windows`属性维护对窗口的引用：
```swift
let w = UIApplication.shared.windows.first!
```

> 不要以为你所知道的那个窗口就是应用的唯一窗口。运行时还可能创建一些神秘的额外窗口，例如`UITextEffectsWindow`和`UIRemoteKeyboardWindow`。

## Experimenting with Views
在本章及后续章节中，你可能希望在自己的项目中尝试操作视图。如果你在创建项目时使用 Xcode 的 Single View App 模板，它会为你生成最简单的应用：包含一个主 storyboard，其中有一个场景，场景中只有一个视图控制器实例及其主视图。正如前面所述，当应用运行时，这个视图控制器会被设置为窗口的 `rootViewController`，其主视图则成为窗口的根视图。只要你将自己的视图添加为该视图控制器主视图的子视图，它们就会在应用启动时出现在界面中。

在 nib 编辑器中，你可以从 Library 中将一个视图拖入主视图，作为子视图添加，这样应用运行时它就会被实例化。但我最初的示例都会在代码中创建视图并添加到界面，那么这段代码该写在哪儿呢？最简单的做法是放在视图控制器的 `viewDidLoad` 方法里——项目模板会为你提供这个方法的空实现，它会在视图第一次出现在界面之前执行一次。

在 `viewDidLoad` 方法中，可以通过 `self.view` 来引用视图控制器的主视图。在我的示例代码里，每次出现 `self.view`，都假设我们正处于一个视图控制器中，此时 `self.view` 就指向该控制器的主视图。
```swift
override func viewDidLoad() {
    super.viewDidLoad() // this is template code
    let v = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
    v.backgroundColor = .red // small red square
    self.view.addSubview(v) // add it to main view
}
```

试一试！用 “Single View App” 模板新建一个项目，然后把 `ViewController` 类的 `viewDidLoad` 方法改成上面的那样。运行应用后，你就能在界面中看到那个小红色的小方块了。

## Subview and Superview
很早以前（其实也并不遥远），每个视图只拥有它自己那块矩形区域。任何不是它子视图的控件都无法出现在这块区域内，因为当它重绘自己矩形时，会将重叠的其他视图部分擦掉；同样，它的子视图也无法绘制到父视图的矩形之外，因为视图只对自己的那一块区域负责。

这些规则后来逐步放宽，自 OS X 10.5 起，Apple 引入了一套全新的视图绘制架构，彻底取消了这些限制。iOS 的视图绘制机制正是基于这套更新后的架构。在 iOS 中，子视图的部分或全部内容可以超出其父视图的范围；一个视图也可以与另一个视图重叠，并且即便不是其子视图，也能部分或完全绘制在它的上方。

图 1-1 展示了三个相互重叠的视图。因为这三个视图都设置了 `backgroundColor`，所以它们在界面上看起来就像三个彩色矩形。然而，仅凭这种视觉效果，你无法判断它们在视图层级中究竟是什么关系。实际上，View 1 和 View 2 是同级视图（它们都直接挂在根视图下），而 View 3 则是 View 2 的子视图。

![](../../../Resource/1-1.png)

![](../../../Resource/1-2.png)

当视图在 nib 中创建时，你可以在 nib 编辑器的文档大纲中查看视图层级，以了解它们之间的真实关系（见图 1-2）。如果视图是通过代码创建的，你自然清楚它们的层级结构，因为是你自己搭建了这一层级。但在可见界面上，这些信息并不会直接显现出来，因为视图可以非常灵活地相互重叠。

当绘制工作量较大且可以拆分为多个区域时，你可以通过关注传入 `draw(_:)` 的参数来提升效率。这个参数是一个 `CGRect`，它指定了需要刷新的视图边界区域。通常，系统会将整个视图的 `bounds` 作为这个区域；但如果你调用带 `CGRect` 参数的 `setNeedsDisplay(_:)`，那么系统只会将你传入的那个矩形作为需要刷新的区域。你可以选择只在该区域内执行绘制；即便你仍对整个视图进行绘制，系统也会将绘制结果裁剪到指定区域内，这样虽然绘制耗时不一定减少，但渲染过程会更加高效。

你可以在图 1-1 中看到这一点：View 3 是 View 2 的子视图，因此它会在 View 2 之上绘制；View 1 与 View 2 同为同级视图，但它在同级列表中靠后，因此会绘制在 View 2 和 View 3 之上。View 1 不可能出现在 View 3 之下却又在 View 2 之上，因为 View 2 和 View 3 是父子关系，它们会作为一组一起绘制——要么都先于 View 1 绘制，要么都在 View 1 之后绘制，取决于它们在同级视图中的顺序。

这层次顺序可以在 nib 编辑器中通过在文档大纲里对视图进行重新排列来控制。（如果你在画布中点击视图，也可以改用菜单 “Editor → Arrange” 下的 “Send to Front”、“Send to Back”、“Send Forward”、“Send Backward” 等命令。）在代码中，也有一系列方法用于调整同级视图的顺序，稍后我们会详细介绍。

以下是视图层级的其他一些影响：
* 如果一个视图从它的父视图中移除或在父视图内被移动，它的所有子视图也会随之移除或移动。
* 视图的透明度会被其子视图继承。
* 视图可以通过 `clipsToBounds` 属性来限制子视图的绘制，使其超出父视图范围的部分不被显示。
* 在内存管理方面，父视图会“拥有”它的子视图，就像数组拥有它的元素一样；父视图会保留对子视图的引用，并负责在某个子视图从该视图的子视图集合中移除，或父视图本身被销毁时，释放对应的子视图。
* 当一个视图的尺寸发生改变时，它的子视图可以自动调整大小（关于这部分内容，我将在本章后面详细说明）。

`UIView` 有一个 `superview` 属性（类型为 `UIView`）和一个 `subviews` 属性（这是一个按从后到前顺序排列的 `UIView` 数组），可以在代码中用来遍历视图层级。此外，还有一个方法 `isDescendant(of:)`，可以检查一个视图是否在任意深度上是另一个视图的子视图。

如果你需要引用某个特定的视图，通常会事先将它作为一个属性来处理，比如通过 outlet。或者，你也可以给视图设置一个数值标签（通过它的 `tag` 属性），然后在视图层级中任意更高层的视图上调用 `viewWithTag(_:)` 来获取该视图。至于如何保证这些标签在其所在层级区域内唯一，就需要你自己来管理了。

在代码中操作视图层次结构非常简单，这正是 iOS 应用富有动态表现力的原因之一。你的代码完全可以将一个视图及其所有子视图从它的 `superview` 中移除，再替换成另一组视图，用户几乎察觉不到！你可以直接这样做，也可以配合动画（第 4 章），或者通过 `UIViewController` 来管理这些变化（第 6 章）。

方法 `addSubview(_:)` 会将一个视图添加为另一个视图的子视图；`removeFromSuperview` 则会将子视图从它的父视图层次中移除。在这两种操作中，如果父视图当前在界面上可见，那么子视图会立即相应地出现或消失；同时，子视图可能还带有自己的子视图，它们也会随之一起添加或移除。将子视图从父视图中移除会释放对它的引用，如果你希望稍后重用该子视图，需要先将它保存到一个变量中以保留对它的引用。

这些动态变化会通过事件的形式通知到视图。要响应该类事件，需要对`UIView`进行子类化，此时你就可以重写以下方法：
* `willRemoveSubview(_:)`, `didAddSubview(_:)`
* `willMove(toSuperview:)`, `didMoveToSuperview`
* `willMove(toWindow:)`, `didMoveToWindow`

调用`addSubview(_:)`时，新视图会被添加到父视图的子视图数组末尾，因此最先被绘制，也就显示在最前面。但有时这并不是我们想要的效果。视图的子视图是有索引的，从 0 开始表示最靠后的那个。系统提供了一些方法，可以让你将子视图插入到指定索引位置，或者插入到某个视图的后面（下方）或前面（上方）；也可以通过索引交换两个同级子视图的位置；还可以将某个子视图一次性移动到所有同级视图的最前面或最后面。
* `insertSubview(_:at:)`
* `insertSubview(_:belowSubview:)`, `insertSubview(_:aboveSubview:)`
* `exchangeSubview(at:withSubviewAt:)`
* `bringSubviewToFront(_:)`, `sendSubviewToBack(_:)`

有趣的是，UIKit 并没有提供一次性移除一个视图所有子视图的命令。不过，因为 `subviews` 数组只是内部子视图列表的一个不可变副本，所以可以遍历它，并逐个调用 `removeFromSuperview()` 来移除每个子视图：

```swift
myView.subviews.forEach { $0.removeFromSuperview() }
```

## Color
视图可以通过 `backgroundColor` 属性来设置背景颜色。如果一个视图仅靠背景颜色来区分，那它就是一个彩色矩形，非常适合作为实验用的媒介，就像图 1-1 中的示例一样。

背景颜色为 `nil`（默认值）的视图背景是透明的，如果该视图本身没有任何额外绘制，就不会出现在界面上！这样的视图完全合理：透明背景的视图可以作为其他视图的容器，使它们一同协作。

颜色是一个 `UIColor` 对象，通常通过其 `.red`、`.blue`、`.green` 和 `.alpha` 分量来指定，这些分量都是介于 0 到 1 之间的 `CGFloat` 值。
```swift
v.backgroundColor = UIColor(red: 0, green: 0.1, blue: 0.1, alpha: 1)
```

还有许多命名颜色，它们以 `UIColor` 类的静态属性形式提供：
```swift
v.backgroundColor = .red
```

在 iOS 13 中，你需要更加谨慎地为界面元素指定颜色。问题在于用户可以在浅色模式和深色模式之间切换，这会引发一连串的颜色变化，从而让硬编码的颜色显得不协调。假设在 Xcode 11 创建的新项目中，我们给 `UIViewController` 的主视图（`self.view`）添加了一个子视图，并将其背景色设为深色：
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let v = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
    v.backgroundColor = UIColor(red: 0.0, green: 0.1, blue: 0.1, alpha: 1.0)
    self.view.addSubview(v)
}
```

如果我们在模拟器中运行，就能看到一个很深色的小方块出现在白色背景上。但如果切换到深色模式，背景会变成黑色，那个深色方块就看不见了。原因是在 iOS 13 中，视图控制器的主视图默认使用的是动态颜色，浅色模式下它是白色，深色模式下它变成了黑色，这就导致我们的深色方块在黑底上“消失”了。

一种解决方法是将 `UIColor` 设为动态颜色。我们可以使用初始化方法 `init(dynamicProvider:)`，并传入一个闭包，这个闭包会接收一个 `UITraitCollection` 并返回对应的颜色。我稍后会在本章讲解 `UITraitCollection` 的含义；目前你只需要知道，它的 `userInterfaceStyle` 属性可能是 `.dark`，也可能不是。
```swift
v.backgroundColor = UIColor { tc in
    switch tc.userInterfaceStyle {
    case .dark:
        return UIColor(red: 0.3, green: 0.4, blue: 0.4, alpha: 1)
    default:
        return UIColor(red: 0, green: 0.1, blue: 0.1, alpha: 1)
    }
}
```

我们创建了自定义的动态颜色，会根据当前模式的不同而改变。在深色模式下，视图的颜色变为深灰色，能够在黑色背景上清晰显示。

> 在模拟器中切换深色模式：在调试栏点击 Environment Overrides 按钮，在弹出的面板右上角打开首个开关即可。

要更简洁地获取动态颜色，可以使用 iOS 13 中由 `UIColor` 提供的大量静态动态色。例如，它们大多以 `.system` 开头（如 `.systemYellow`），也有一些语义化名称（如 `.label`）。详情请参阅 Apple 的《人机界面指南》。

你也可以在资源目录中设计一个自定义命名颜色。在属性检查器的 Appearances 弹出菜单中切换到 Any, Dark，就会出现两个颜色插槽：一个用于深色模式，一个用于其他模式，就和前面的示例代码效果一致。假设你已经这样配置，并将颜色命名为 `myDarkColor`，那么你可以这样使用：
```swift
view.backgroundColor = UIColor(named: "myDarkColor")
```

你在资源目录中定义的自定义命名颜色，也会出现在 Xcode 的库面板中；当你选中某个视图时，在属性检查器的颜色弹出菜单里同样可以找到这些颜色。

## Visibility and Opacity
有三个属性与视图的可见性和不透明度有关：  
isHidden  
视图可以通过将 `isHidden` 属性设为 true 来隐藏，再将其设为 false 来重新显示。隐藏视图会把它（及其子视图）从可见界面中移除，但不会改变视图层级结构。被隐藏的视图通常不会接收触摸事件，因此对用户而言它仿佛不存在，但在代码中它仍然保留着，可以随时操作。  

alpha  
通过设置 `alpha` 属性，可以让视图呈现部分或完全透明的效果：`1.0` 表示完全不透明，`0.0` 表示完全透明，中间可取任意值。这一属性会影响视图背景色和内容的透明度表现。如果一个视图既显示图像又设置了背景色，当 `alpha` 值小于 1 时，背景色会透过图像显现（视图后面的内容也会随之透出）。更重要的是，它还会影响子视图的透明度！如果父视图的 `alpha` 是 `0.5`，那么无论子视图自身设置多高的透明度，它在界面上看到的都不会超过 `0.5`，因为子视图的透明度是相对于父视图的透明度来叠加的。一个完全透明（或几乎透明）的视图，就像将 `isHidden` 设为 `true`：视图及其子视图都不可见，且（通常）无法响应触摸。

更复杂的是，颜色本身也有 alpha 值。一个视图的 `alpha` 值可以是 1.0，但如果它的 `backgroundColor` 的 alpha 小于 1.0，背景仍然是透明的。

isOpaque  
这个属性有别于其他属性；改变它并不会影响视图的外观，它只是一个告诉绘图系统的提示。如果一个视图完全被不透明内容填充，且其 `alpha` 为 1.0，也就没有任何透明度，那么你应该将 `isOpaque` 设置为 true，这样系统就能更高效地绘制（性能开销更小）。否则，应将 `isOpaque` 设置为 false。需要注意的是，当你设置视图的 `backgroundColor` 或 `alpha` 时，`isOpaque` 并不会自动更新，是否正确设置完全取决于你；它的默认值（令人意外地）是 true。







## Trait Collections

## Layout

## Configuring Layout in the Nib

## Xcode View Features

## Layout Events