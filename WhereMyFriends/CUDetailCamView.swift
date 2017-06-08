import UIKit

class CUDetailCamView: UIView {
    
    @IBOutlet weak var address: UILabel?
    @IBOutlet weak var image: UIImageView?
    
    @IBOutlet weak var backView: UIView? {
        didSet {
            backView?.layer.borderColor   = #colorLiteral(red: 0.9925034642, green: 0.8121734858, blue: 0, alpha: 1).cgColor
            backView?.layer.borderWidth   = 0.35
            backView?.layer.cornerRadius  = backView!.frame.size.height / 2
            backView?.layer.masksToBounds = true
        }
    }
    
    var number: String!
    var client: Bool!
    

}
