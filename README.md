# ASSeatsSelectionView
A seats selection view. Used in movie seats selection or others.

### Features
- UITableView like design.
- You can custom width and image for every seats

### ScreenShots

<img src="https://github.com/falcon11/ASSeatsSelection/blob/develop/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202017-12-25%20at%2011.16.05.png?raw=true" width=315>
<img src="https://github.com/falcon11/ASSeatsSelection/blob/develop/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202017-12-25%20at%2011.16.15.png?raw=true" width=315>

### Usage
Just copy file in the Views and Models Folder to your project
By default there is no model concept, but you can use a seat model like [ASSeatModel](ASSeatsSelection/ASSeatsSelection/Models/ASSeatModel.swift) or your custom model in yourself dataSource.
There are tow way to configure the seatsSelectionView
```swift
// common configure
func setupSeatsView() -> Void {
seatsView.hallName = "大银幕"
seatsView.hallLogoSize = CGSize(width: 200, height: 20)
seatsView.hallNameColor = UIColor.green
seatsView.indicatorColor = UIColor.orange
seatsView.indicatorViewHeight = 64
seatsView.rowIndexViewTextColor = UIColor.orange
seatsView.rowIndexViewBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
seatsView.dataSource = self
seatsView.delegate = self
}

// more swift like configuration
func setupSeatsViewWithConfiguration() {
let configuration: ASSeatsSelectionConfigure = [
.hallLogoConfiguration(.hallName("7-11")),
.hallLogoConfiguration(.hallLogoSize(CGSize(width: 200, height: 20))),
.hallLogoConfiguration(.hallNameColor(UIColor.green)),
.indicatorConfiguration(.indicatorBorderColor(UIColor.green)),
.indicatorConfiguration(.indicatorViewHeight(64)),
.indicatorConfiguration(.indicatorBorderColor(UIColor.orange)),
.rowIndexConfiguration(.backgroundColor(UIColor.cyan.withAlphaComponent(0.5))),
.rowIndexConfiguration(.titleColor(UIColor.purple)),
.centerLineConfiguration(.lineColor(UIColor.red)),
.centerLineConfiguration(.lineWidth(1)),
.centerLineConfiguration(.isHiddenLine(.Horizontal, true)),
]
seatsView.setupWithConfiguration(configuration: configuration)
seatsView.dataSource = self
seatsView.delegate = self
}
```
Then you should implement ASSeatsSelectionViewDataSource, ASSeatsSelectionViewDelegate(optional)
```swift
@objc protocol ASSeatsSelectionViewDataSource: NSObjectProtocol {

func numberOfRowsIn(seatsSelectionView: ASSeatsSelectionView) -> Int

@objc optional func  seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, numberOfColumnsIn row: Int) -> Int

@objc optional func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, seatImageIn row:Int, column:Int, completion:(_ image: UIImage?)->Void)

@objc optional func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, seatWidthIn row:Int, column: Int) -> CGFloat

@objc optional func heightForRowIn(seatsSelectionView: ASSeatsSelectionView) -> CGFloat

@objc optional func seatsSelectionView(seatsSelectionView: ASSeatsSelectionView, indexTitleIn row: Int) -> String

}

@objc protocol ASSeatsSelectionViewDelegate: NSObjectProtocol {
@objc optional func seatsSelectionView(_ seatsSelectionView: ASSeatsSelectionView, didSelectAt row: Int, column: Int)
}
```
For more details you can check out the [ViewController](ASSeatsSelection/ASSeatsSelection/ViewController.swift) file.

