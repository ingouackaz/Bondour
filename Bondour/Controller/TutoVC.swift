//
//  TutoVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class TutoVC: UIViewController, UIPageViewControllerDataSource {

    var pageTitles :Array<String> = ["Bondour !", "Dis zuste", "Bondour autour de toi !"]
    var pageViewController : UIPageViewController?
    var _images  = [UIImage(named: "blue"),UIImage(named: "pink"),UIImage(named: "yellow")]
    var currentIndex : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index, obj) in enumerate(_images)
        {
            
            
            self.pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
            self.pageViewController!.dataSource = self
            
            
            let startingViewController: PageTutoVC = self.viewControllerAtIndex(0)!
            let viewControllers: NSArray = [startingViewController]
            self.pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: false, completion: nil)            
            self.addChildViewController(self.pageViewController!)
            self.view.addSubview(self.pageViewController!.view)
            self.pageViewController!.didMoveToParentViewController(self)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageTutoVC).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageTutoVC).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> PageTutoVC?
    {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController : PageTutoVC = self.storyboard!.instantiateViewControllerWithIdentifier("pageTuto") as! PageTutoVC
        
        pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.currentImage = _images[index]!
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
