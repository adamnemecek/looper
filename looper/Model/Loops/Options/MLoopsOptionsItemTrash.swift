import UIKit

class MLoopsOptionsItemTrash:MLoopsOptionsItem
{
    init()
    {
        let image:UIImage = #imageLiteral(resourceName: "assetLoopsTrash")
        
        super.init(image:image)
    }
    
    override func selected(controller:CLoops, model:MLoopsItem)
    {
        controller.delete(model:model)
    }
}
