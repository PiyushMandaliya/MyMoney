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
    
    var arrayOnBoarding: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setScrollView()
        setButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}

//MARK: -  Config ScrollView
extension OnBoardViewController {
    
    func setScrollView(){
        arrayOnBoarding = self.createSlides()
        self.setupSlideScrollView(slides: arrayOnBoarding)
    }
    
    func setupSlideScrollView(slides : [UIView]) {
        self.scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.scrollView.bounds.height))
        scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(slides.count), height: (self.scrollView.bounds.height))
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.view.bounds.width * CGFloat(i), y: 0, width: self.view.bounds.width, height: (self.scrollView.bounds.height))
            scrollView.addSubview(slides[i])
        }
    }
    
    func createSlides() -> [UIView] {
        var tempArrayOnBoarding: [UIView] = []
        for index in 0..<K.onBoardingMessage.count{
            var slide: OnBoardingView = OnBoardingView()
            slide = Bundle.main.loadNibNamed("OnBoardingView", owner: self, options: nil)?.first as! OnBoardingView
            let img = UIImage(named: K.onBoardingImage[index])
            slide.image.image = img?.imageWithColor(color1: UIColor(named: "ColorTextPrimary")!)
            slide.lblTitle.text = Array(K.onBoardingMessage.keys)[index]
            slide.lblDescription.text = Array(K.onBoardingMessage.values)[index]
            tempArrayOnBoarding.append(slide)
        }
        return tempArrayOnBoarding
    }
    
    
}



//MARK: -  Action Handler
extension OnBoardViewController {
    @IBAction func onSkipPressed(_ sender: UIButton) {
        goToHome()
    }
    
    @IBAction func onNextOrFinshPressed(_ sender: UIButton) {
        let currentPage = pageController.currentPage
        if currentPage == 0 || currentPage == 1{
            pageController.currentPage += 1
            let x = CGFloat(pageController.currentPage) * scrollView.frame.size.width
            scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            setSkipButton()
            setButtons()
        }else{
            goToHome()
        }
    }
}


//MARK: -  Config Buttons

extension OnBoardViewController {
    private func setButtons(){
        let currentPage = pageController.currentPage

        if(currentPage == 0 || currentPage == 1){
            self.btnNextOrFinish.setTitle("Next", for: .normal)
            self.btnSkip.setTitle("Skip", for: .normal)
            btnSkip.isHidden = false
            btnSkip.alpha = 1.0
        }else{
            self.btnNextOrFinish.setTitle("Finish", for: .normal)
            self.btnSkip.setTitle("Skip", for: .normal)
            self.setSkipButton()

        }
    }
    
    
    
    private func goToHome(){
        print("Go to Home")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tapBarViewController") as? TapBarViewController
        self.navigationController?.pushViewController(vc!, animated: true)
//        self.present(vc!, animated:true, completion:nil)

    }
    
    private func setSkipButton(){
        if pageController.currentPage == 2{
            UIView.animate(withDuration: 0.1, animations: {
                self.btnSkip.alpha = 0
            }) { (finished) in
                self.btnSkip.isHidden = finished
            }
        }
    }
}


//MARK: -  ScrollViewDelegate
extension OnBoardViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(scrollView){
            let pageIndex = (scrollView.contentOffset.x/self.view.frame.width).rounded()
            pageController.currentPage = Int(pageIndex)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setButtons()
    }
    
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
