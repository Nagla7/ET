//
//  IssueRequestController.swift
//  ET
//
//  Created by rano2 on 03/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class IssueRequestController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return 3}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell:RequestCell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:indexPath) as! RequestCell
      //cell.frame.origin.x=self.view.frame.width*CGFloat(indexPath.row)+CGFloat(22)
        
        // let frame=CGRect.init(x:cell.frame.origin.x, y:cell.frame.origin.y, width:cell.frame.size.width, height:cell.frame.size.height)
       
    let v=cell.text(frame:frames[indexPath.row]) as! UIView
  //  v.frame.origin.x=self.view.frame.width*CGFloat(indexPath.row)+CGFloat(22)
    cell.addSubview(v)
    cell.id=indexPath.row
        
        
        return cell}
    

    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var Request: UICollectionView!
    var frames=[CGRect]()
    override func viewDidLoad() {
        super.viewDidLoad()
        frames=[CGRect.init(x:self.view.frame.width*CGFloat(0)+CGFloat(22), y:CGFloat(5.5), width:CGFloat(374), height:CGFloat(467)),CGRect.init(x:self.view.frame.width*CGFloat(1)+CGFloat(22), y:CGFloat(5.5), width:CGFloat(374), height:CGFloat(467)),CGRect.init(x:self.view.frame.width*CGFloat(2)+CGFloat(22), y:CGFloat(5.5), width:CGFloat(374), height:CGFloat(467))
        ]
Request.delegate=self
Request.dataSource=self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let page=scrollView.contentOffset.x/scrollView.frame.width
        self.page.currentPage=Int(page)
    }
    


}
