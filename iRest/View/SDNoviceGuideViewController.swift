//
//  SDNoviceGuideViewController.swift
//  iRest
//
//  Created by Sword on 2022/9/7.
//  Copyright © 2022 DengFeng.Su. All rights reserved.
//

import Cocoa

//public class AnimatingScrollView: NSScrollView {
//
//    // This will override and cancel any running scroll animations
//    override public func scroll(_ clipView: NSClipView, to point: NSPoint) {
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        contentView.setBoundsOrigin(point)
//        CATransaction.commit()
//        super.scroll(clipView, to: point)
//    }
//
//    public func scroll(toPoint: NSPoint, animationDuration: Double) {
//        NSAnimationContext.beginGrouping()
//        NSAnimationContext.current.duration = animationDuration
//        contentView.animator().setBoundsOrigin(toPoint)
//        reflectScrolledClipView(contentView)
//        NSAnimationContext.endGrouping()
//    }
//}

class SDNoviceGuideViewController: NSViewController {
    
    static var isShow = false
    var completeBlock: (() -> ())?
    var lastAnimation : NSViewAnimation?
    
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var nextBtn: NSButton!
        
    let xibNames = ["SDNoviceGuideView1", "SDNoviceGuideView2"]
    var sumStep = 0
    var currStep = 1 {
        didSet {
            if let lastAnimation = lastAnimation {
                lastAnimation.stop()
            }
            
            let start = contentView.frame
            let end = CGRect(origin: NSPoint(x: -CGFloat(currStep - 1) * view.bounds.width, y: contentView.frame.minY), size: contentView.frame.size)
            
            let animation = NSViewAnimation(duration: 0.5, animationCurve: .easeInOut)
            animation.viewAnimations = [[NSViewAnimation.Key.target: contentView!, /*NSViewAnimation.Key.effect: NSViewAnimation.EffectName.fadeIn,*/ NSViewAnimation.Key.startFrame: start, NSViewAnimation.Key.endFrame: end]]
            
            //NSAnimationBlocking阻塞
            //NSAnimationNonblocking异步不阻塞
            //NSAnimationNonblockingThreaded线程不阻塞
            animation.animationBlockingMode = .blocking
            animation.start()
            
            lastAnimation = animation
            
            if sumStep == currStep {
                nextBtn.setTitle(title: SDLocalized.string("done"), NSColor.white).setBackgroundColor(NSColor(red: 51/255.0, green: 131/255.0, blue: 0, alpha: 1))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setBackgroundColor(NSColor.darkGray).setCornerRadius(12)
        nextBtn.setTitle(title: SDLocalized.string("next"), NSColor.white).setBackgroundColor(NSColor(red: 0, green: 128/255.0, blue: 1.0, alpha: 1.0)).setCornerRadius(4)
        
        var allViews = [NSView]()
        
        for name in xibNames {
            var levelObjects: NSArray?
//            Bundle.main.loadNibNamed(name, owner: nil, topLevelObjects: &views)
            NSNib(nibNamed: name, bundle: nil)?.instantiate(withOwner: nibBundle, topLevelObjects: &levelObjects)
            
            let views = levelObjects?.compactMap {
                $0 as? NSView
            }
            if let view = views?.first {
                allViews.append(view)
            }
        }
   
        let width = view.bounds.width
        sumStep = allViews.count
        contentView.frame.size.width = CGFloat(allViews.count) * width
        
        for i in 0..<allViews.count {
            let view = allViews[i]
            contentView.addSubview(view)
            view.frame.origin = CGPoint(x:  CGFloat(i) * width, y: 0)
        }
    }
    
    class func show() {
        
        let vc = SDNoviceGuideViewController(nibName: "SDNoviceGuideViewController", bundle: nil)
        let window = NSWindow(contentRect: vc.view.bounds, styleMask: .fullSizeContentView, backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        
        window.contentViewController = vc
        window.hasShadow = false
        window.backgroundColor = NSColor.clear
        
        window.makeKeyAndOrderFront(nil)
        window.center()
        
        Self.isShow = true
        vc.completeBlock = { [weak window] in
            window?.close()
            Self.isShow = false
        }
    }

    @IBAction func nextAction(_ sender: Any) {
        if sumStep <= currStep {
            skipAction(sender)
        } else {
            currStep += 1
        }
    }
    
    @IBAction func skipAction(_ sender: Any) {
        guard let completeBlock = completeBlock else {
            return
        }
        completeBlock()
    }
}
