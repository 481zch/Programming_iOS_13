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
完全可以编写一个不使用主 storyboard 的应用：



## Trait Collections

## Layout

## Configuring Layout in the Nib

## Xcode View Features

## Layout Events