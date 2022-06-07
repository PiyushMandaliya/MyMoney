//
//  OnBoardingViewController.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-10.
//

import Foundation
import UIKit

class OnBoardViewController: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNextOrFinish: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBoard: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setScrollView()
        configureButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}


//MARK: - Outlet Actions
extension OnBoardViewController {
    
    @IBAction func onSkipPressed(_ sender: UIButton) {
        navigateToHomeVC()
    }
    
    @IBAction func onNextOrFinshPressed(_ sender: UIButton) {
        let currentPage = pageController.currentPage
        if currentPage == 0 || currentPage == 1 {
            pageController.currentPage += 1
            let x = CGFloat(pageController.currentPage) * scrollView.frame.size.width
            scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            configureSkipButton()
            configureButtons()
        }else {
            navigateToHomeVC()
        }
    }
}

//MARK: -  ScrollViewDelegate
extension OnBoardViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(scrollView){
            let pageIndex               = (scrollView.contentOffset.x/self.view.frame.width).rounded()
            pageController.currentPage  = Int(pageIndex)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        configureButtons()
    }
}


//MARK: -  UILayout

extension OnBoardViewController {
    
    func setScrollView() {
        let slides                                  = createSlides()

        scrollView.delegate                         = self
        scrollView.setUpOnBoardScrollView()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.scrollView.bounds.height))
        scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(slides.count), height: (self.scrollView.bounds.height))

        for i in 0 ..< slides.count {
            slides[i].frame         = CGRect(x: self.view.bounds.width * CGFloat(i), y: 0, width:    self.view.bounds.width, height: (self.scrollView.bounds.height))
            scrollView.addSubview(slides[i])
        }
    }
    
    
    func createSlides() -> [UIView] {
        var tempArrayOnBoarding: [UIView] = []
        for index in 0..<onBoarding.messages.count {
            let slide: OnBoardingView   = Bundle.main.loadNibNamed("OnBoardingView", owner: self, options: nil)?.first as! OnBoardingView
            slide.set(for: index)
            tempArrayOnBoarding.append(slide)
        }
        return tempArrayOnBoarding
    }
    
    
    private func configureButtons() {
        let currentPage = pageController.currentPage

        if(currentPage <=	 1){
            self.btnNextOrFinish.setTitle("Next", for: .normal)
            btnSkip.isHidden = false
            btnSkip.alpha = 1.0
        }else{
            self.btnNextOrFinish.setTitle("Finish", for: .normal)
            self.configureSkipButton()
        }
    }
    
    
    private func navigateToHomeVC(){
        let tapbarVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tapBarViewController") as? TapBarViewController
        self.navigationController?.pushViewController(tapbarVC!, animated: true)
    }
    
    
    private func configureSkipButton(){
        if pageController.currentPage == 2 {
            UIView.animate(withDuration: 0.1, animations: {
                self.btnSkip.alpha = 0
            }) { (finished) in
                self.btnSkip.isHidden = finished
            }
        }
    }
}
