import UIKit

class MCameraMoreItemActionsOptionRotate:MCameraMoreItemActionsOption
{
    init()
    {
        super.init(image:#imageLiteral(resourceName: "assetCameraRotate"))
    }
    
    override func selected(controller:CCameraMore?)
    {
        guard
            
            let record:MCameraRecordEditable = controller?.record
            
        else
        {
            return
        }
        
        controller?.controller.rotate(item:record)
    }
}
