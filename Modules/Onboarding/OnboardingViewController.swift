//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 25.12.2023.
//

import Foundation
import UIKit

final class OnboardingViewController: UIPageViewController {
    lazy private var pages: [UIViewController] = {
        let first = OnboardingViewControllerBase(imageName: "background 1", labelText: "Отслеживайте только то, что хотите")
        let second = OnboardingViewControllerBase(imageName: "background 2", labelText: "Даже если это не литры воды и йога")
        
        return [first, second]
    }()
    
    lazy private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = UIColor(named: "Black")
        pageControl.pageIndicatorTintColor = UIColor(named: "Black")?.withAlphaComponent(0.3)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
    }
    
    
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

