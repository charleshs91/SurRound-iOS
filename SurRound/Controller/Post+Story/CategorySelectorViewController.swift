//
//  CategorySelectorViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/5.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class CategorySelectorViewController: UIViewController {

    deinit {
        debugPrint("$ deinit: CategorySelectorViewController")
    }
    
    static func storyboardInstance() -> CategorySelectorViewController? {
        return UIStoryboard.newPost.instantiateViewController(
            identifier: String(describing: CategorySelectorViewController.self)
            ) as? CategorySelectorViewController
    }
    
    @IBOutlet var categoryButtons: [SRVerticalAlignedButton]!
    
    @IBOutlet var popUpView: UIView!
    
    // Private Constants
    private let popUpViewHeight: CGFloat = 275
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentPopUpView()
    }
    
    // MARK: - User Actions
    @IBAction func didTapCloseBtn(_ sender: UIButton) {
        
        dismissPopUpView()
    }
    
    @IBAction func didTapCategoryBtn(_ sender: SRVerticalAlignedButton) {
        
        guard let tapped = categoryButtons.firstIndex(of: sender),
            let category = PostCategory(rawValue: tapped) else { return }
        
        guard let nav = UIStoryboard.newPost.instantiateInitialViewController() as? UINavigationController,
            let newPostVC = nav.viewControllers.first as? NewPostViewController else { return }
        
        newPostVC.postCategory = category
        
        dismissThenPresent(nav)
    }
    
    // MARK: - Private Methods
    private func presentPopUpView() {
        
        popUpView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: popUpViewHeight)
        popUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popUpView.layer.cornerRadius = 16
        
        view.addSubview(popUpView)
        
        let yPos = view.frame.height - popUpView.frame.height
        
        UIViewPropertyAnimator(
            duration: 0.3,
            curve: .easeInOut,
            animations: {
                self.popUpView.frame.origin = CGPoint(x: 0, y: yPos)
            }
        ).startAnimation()
    }
    
    private func dismissPopUpView(completion: (() -> Void)? = nil) {
        
        let endYPosition = view.frame.height
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.popUpView.frame.origin = CGPoint(x: 0, y: endYPosition)
                
        }, completion: { _ in
            
            self.popUpView.removeFromSuperview()
            self.presentingViewController?.dismiss(animated: false, completion: completion)
        })
    }
    
    private func dismissThenPresent(_ viewController: UIViewController) {
        
        dismissPopUpView(completion: {
            let rootVC = AppDelegate.shared.window!.rootViewController!
            viewController.modalPresentationStyle = .overCurrentContext
            rootVC.present(viewController, animated: true, completion: nil)
        })
    }
}
