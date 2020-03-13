//
//  SwipeTransitionAnimator.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/3.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SwipeTransitionAnimator: NSObject {
    
    private let viewControllers: [UIViewController]?
    private let transitionDuration: Double
    
    init(viewControllers: [UIViewController]?, duration: Double = 0.2) {
        
        self.viewControllers = viewControllers
        self.transitionDuration = duration
    }
    
    private func getIndex(ofViewController targetVC: UIViewController) -> Int? {
        
        guard let viewControllers = self.viewControllers else { return nil }
        
        for (index, thisVC) in viewControllers.enumerated() where thisVC == targetVC {
            return index
        }
        return nil
    }
}

extension SwipeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(ofViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = toVC.view,
            let toIndex = getIndex(ofViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        transitionContext.containerView.addSubview(toView)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.transitionDuration, delay: .zero, animations: {
            fromView.frame = fromFrameEnd
            toView.frame = frame
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
