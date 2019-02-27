//
//  SwipingPhotosController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/17/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var controllers = [UIViewController]() // blank array
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })

            setViewControllers([controllers.first!], direction: .forward, animated: false)
            _ = configurePageControl
        }
    }
    
    var pageControl = UIPageControl()


    private lazy var configurePageControl: Void = {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: 0,width: 20,height: 50))
        self.pageControl.numberOfPages = controllers.count
        self.pageControl.currentPage = 0
        self.pageControl.alpha = 0.8
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.8)
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.view.addSubview(pageControl)
        let paddingTop = UIApplication.shared.statusBarFrame.height
        pageControl.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: paddingTop, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 8))
        pageControl.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1).isActive = true
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = controllers.index(of: pageContentViewController)!
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index -  1]
    }
    
}

class PhotoController: UIViewController {
    
    let imageView = UIImageView()
    
    //provide initiallizer that take in a url instead
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
    }
//        imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
    }
    
    
}


//    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
//    fileprivate let deselectedBarColor = UIColor(white: 1, alpha: 0.5)
//
//    fileprivate func setupBarViews() {
//        cardViewModel.imageUrls.forEach { (imageUrl) in
//
//                let barView = UIView()
//                barView.backgroundColor = deselectedBarColor
//                barView.layer.cornerRadius = 4
//                barView.width(8)
//                barView.height(8)
//                barsStackView.addArrangedSubview(barView)
//            }
//        barsStackView.arrangedSubviews.first?.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.7882352941, blue: 0.8156862745, alpha: 1)
//        barsStackView.spacing = 4
//        barsStackView.distribution = .fillEqually
//
//        view.addSubview(barsStackView)
//        let paddingTop = UIApplication.shared.statusBarFrame.height
//        barsStackView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: paddingTop, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 8))
//        barsStackView.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1).isActive = true
//    }
//
//    private func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//        let currentPhotoController = viewControllers?.first
//        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
//            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
//            barsStackView.arrangedSubviews[index].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.7882352941, blue: 0.8156862745, alpha: 1)
//        }
//
//    }
