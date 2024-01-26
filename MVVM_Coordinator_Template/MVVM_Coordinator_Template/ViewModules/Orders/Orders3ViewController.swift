import UIKit

final class Orders3ViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Orders 3"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
    }
}
