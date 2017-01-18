import UIKit

class VCameraHeader:UICollectionReusableView
{
    private weak var controller:CCamera?
    private weak var buttonShoot:VCameraActiveButton!
    private weak var buttonNext:VCameraActiveButton!
    private weak var layoutShootLeft:NSLayoutConstraint!
    private let kButtonsTop:CGFloat = 90
    private let kButtonsHeight:CGFloat = 60
    private let kButtonsWidth:CGFloat = 60
    private let kBorderHeight:CGFloat = 1
 
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        clipsToBounds = true
        backgroundColor = UIColor.clear
        
        let buttonHelp:UIButton = UIButton()
        buttonHelp.translatesAutoresizingMaskIntoConstraints = false
        buttonHelp.setImage(
            #imageLiteral(resourceName: "assetLoopsHelp").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
            for:UIControlState.normal)
        buttonHelp.setImage(
            #imageLiteral(resourceName: "assetLoopsHelp").withRenderingMode(UIImageRenderingMode.alwaysTemplate),
            for:UIControlState.highlighted)
        buttonHelp.imageView!.contentMode = UIViewContentMode.center
        buttonHelp.imageView!.clipsToBounds = true
        buttonHelp.imageView!.tintColor = UIColor.genericAlternative
        buttonHelp.addTarget(
            self,
            action:#selector(actionHelp(sender:)),
            for:UIControlEvents.touchUpInside)
        
        let buttonShoot:VCameraActiveButton = VCameraActiveButton(
            image:#imageLiteral(resourceName: "assetCameraShoot"))
        buttonShoot.addTarget(
            self,
            action:#selector(actionShoot(sender:)),
            for:UIControlEvents.touchUpInside)
        buttonShoot.active()
        self.buttonShoot = buttonShoot
        
        let buttonNext:VCameraActiveButton = VCameraActiveButton(
            image:#imageLiteral(resourceName: "assetGenericNext"))
        buttonNext.addTarget(
            self,
            action:#selector(actionProcess(sender:)),
            for:UIControlEvents.touchUpInside)
        self.buttonNext = buttonNext
        
        let border:VBorder = VBorder(color:UIColor(white:0, alpha:0.2))
        
        addSubview(border)
        addSubview(buttonHelp)
        addSubview(buttonShoot)
        addSubview(buttonNext)
        
        NSLayoutConstraint.equalsHorizontal(
            view:border,
            toView:self)
        NSLayoutConstraint.bottomToBottom(
            view:border,
            toView:self)
        NSLayoutConstraint.height(
            view:border,
            constant:kBorderHeight)
        
        NSLayoutConstraint.topToTop(
            view:buttonShoot,
            toView:self,
            constant:kButtonsTop)
        NSLayoutConstraint.height(
            view:buttonShoot,
            constant:kButtonsHeight)
        layoutShootLeft = NSLayoutConstraint.leftToLeft(
            view:buttonShoot,
            toView:self)
        NSLayoutConstraint.width(
            view:buttonShoot,
            constant:kButtonsWidth)
        
        NSLayoutConstraint.topToTop(
            view:buttonNext,
            toView:self,
            constant:kButtonsTop)
        NSLayoutConstraint.height(
            view:buttonNext,
            constant:kButtonsHeight)
        NSLayoutConstraint.rightToRight(
            view:buttonNext,
            toView:self)
        NSLayoutConstraint.width(
            view:buttonNext,
            constant:kButtonsWidth)
        
        NSLayoutConstraint.topToTop(
            view:buttonHelp,
            toView:self,
            constant:kButtonsTop)
        NSLayoutConstraint.height(
            view:buttonHelp,
            constant:kButtonsHeight)
        NSLayoutConstraint.leftToLeft(
            view:buttonHelp,
            toView:self)
        NSLayoutConstraint.width(
            view:buttonHelp,
            constant:kButtonsWidth)
    }
    
    required init?(coder:NSCoder)
    {
        fatalError()
    }
    
    override func layoutSubviews()
    {
        let width:CGFloat = bounds.maxX
        let remainButton:CGFloat = width - kButtonsWidth
        let marginButton:CGFloat = remainButton / 2.0
        layoutShootLeft.constant = marginButton
        
        super.layoutSubviews()
    }
    
    //MARK: actions
    
    func actionHelp(sender button:UIButton)
    {
        controller?.help()
    }
    
    func actionShoot(sender button:VCameraActiveButton)
    {
        button.notActive()
        
        guard
        
            let plus:Bool = MSession.sharedInstance.settings?.plus,
            let currentRecords:Int = MSession.sharedInstance.camera?.records.count
        
        else
        {
            button.active()
            
            return
        }
        
        if !plus && currentRecords >= MSession.kFroobMaxRecords
        {
            button.active()
            controller?.goPlus()
        }
        else
        {
            controller?.shoot()
        }
    }
    
    func actionProcess(sender button:VCameraActiveButton)
    {
        button.notActive()
        controller?.next()
    }
    
    //MARK: public
    
    func config(controller:CCamera)
    {
        self.controller = controller
        refresh()
    }
    
    func refresh()
    {
        buttonShoot.active()
        
        guard
        
            let model:MCamera = MSession.sharedInstance.camera
        
        else
        {
            buttonNext.notActive()
            
            return
        }
        
        if model.records.isEmpty
        {
            buttonNext.notActive()
        }
        else
        {
            if model.hasActive()
            {
                buttonNext.active()
            }
            else
            {
                buttonNext.notActive()
            }
        }
    }
}
