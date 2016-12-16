import UIKit

class VHomeControl:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private weak var controller:CHome!
    private weak var collectionView:UICollectionView!
    let model:MHomeControl
    
    init(controller:CHome)
    {
        model = MHomeControl()
        
        super.init(frame:CGRect.zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        self.controller = controller
        
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flow.headerReferenceSize = CGSize.zero
        flow.footerReferenceSize = CGSize.zero
        flow.scrollDirection = UICollectionViewScrollDirection.horizontal
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.sectionInset = UIEdgeInsets.zero
        
        let collectionView:UICollectionView = UICollectionView(
            frame:CGRect.zero,
            collectionViewLayout:flow)
        collectionView.clipsToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            VHomeControlCell.self,
            forCellWithReuseIdentifier:
            VHomeControlCell.reusableIdentifier)
        self.collectionView = collectionView
        
        addSubview(collectionView)
        
        let layoutCollectionTop:NSLayoutConstraint = NSLayoutConstraint.topToTop(
            view:collectionView,
            toView:self,
            constant:0)
        let layoutCollectionBottom:NSLayoutConstraint = NSLayoutConstraint.bottomToBottom(
            view:collectionView,
            toView:self,
            constant:0)
        let layoutCollectionLeft:NSLayoutConstraint = NSLayoutConstraint.leftToLeft(
            view:collectionView,
            toView:self,
            constant:0)
        let layoutCollectionRight:NSLayoutConstraint = NSLayoutConstraint.rightToRight(
            view:collectionView,
            toView:self,
            constant:0)
        
        addConstraints([
            layoutCollectionTop,
            layoutCollectionBottom,
            layoutCollectionLeft,
            layoutCollectionRight])
    }
    
    required init?(coder:NSCoder)
    {
        fatalError()
    }
    
    //MARK: private
    
    private func modelAtIndex(index:IndexPath) -> MHomeControlItem
    {
        let item:MHomeControlItem = model.items[index.item]
        
        return item
    }
    
    //MARK: collectionView delegate
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        let width:CGFloat = collectionView.bounds.maxX
        let height:CGFloat = collectionView.bounds.maxY
        let items:CGFloat = CGFloat(model.items.count)
        let widthPerCell:CGFloat = width / items
        let size:CGSize = CGSize(width:widthPerCell, height:height)
        
        return size
    }
    
    func numberOfSections(in collectionView:UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
    {
        let count:Int = model.items.count
        
        return count
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell
    {
        let item:MHomeControlItem = modelAtIndex(index:indexPath)
        let cell:VHomeControlCell = collectionView.dequeueReusableCell(
            withReuseIdentifier:VHomeControlCell.reusableIdentifier,
            for:indexPath) as! VHomeControlCell
        cell.config(
            model:item,
            controller:controller)
        
        return cell
    }
}
