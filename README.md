# navigationBar

## 目录
1. 默认 navigationBar
2. 替换返回按钮
3. 替换返回效果

### 1. 默认 navigationBar
> 新建项目-> editor -> embed in -> Navigation Controller
> 添加一个 viewController  ，设置不同的颜色。

默认效果：

![nav1.0-w400](media/nav1.0.gif)

### 2. 替换返回按钮

#### 2.1 替换返回按钮

```swift
import UIKit

class OtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftBtn = UIButton.init(type: UIButtonType.system)
        leftBtn.frame = CGRect(x:0 ,y:0, width:0, height:0)
        leftBtn.setBackgroundImage(UIImage.init(named: "nav_back"), for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(leftBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
    }
    
    func leftBtnAction(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
```

效果：

![nav2.1w400](media/nav2.1.png)

#### 2.2 调整左侧间距

```swift
import UIKit

class OtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftBtn = UIButton.init(type: UIButtonType.system)
        leftBtn.frame = CGRect(x:0 ,y:0, width:25, height:25)
        leftBtn.setBackgroundImage(UIImage.init(named: "nav_back"), for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(leftBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spaceItem.width = -15
        let leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItems = [spaceItem,leftBarButtonItem]
    }
    
    func leftBtnAction(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
```

效果：
![nav2.2w400](media/nav2.2.png)

#### 2.3 右滑失效解决
> 细心的小伙伴会发现，向右滑动不能返回了。

```swift
// 遵守协议
class OtherViewController: UIViewController,UIGestureRecognizerDelegate {
```

```swift
// 设置代理
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
```

效果： 小伙伴又可以尽情的玩耍了

![nav2.3w400](media/nav2.3.gif)

