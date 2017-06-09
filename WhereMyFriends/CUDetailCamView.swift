import UIKit

class CUDetailCamView: UIView {
    @IBOutlet private weak var view: UIView!
    
    @IBOutlet weak var address: UILabel?
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var image: UIImageView?
    
    var number: String!
    var client: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.layer.borderColor   = #colorLiteral(red: 0.9925034642, green: 0.8121734858, blue: 0, alpha: 1).cgColor
        view.layer.borderWidth   = 0.85
        view.layer.cornerRadius  = view.frame.size.height / 2
        view.layer.masksToBounds = true
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
