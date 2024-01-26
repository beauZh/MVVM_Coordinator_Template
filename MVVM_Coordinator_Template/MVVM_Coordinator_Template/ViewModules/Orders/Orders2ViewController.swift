import UIKit

class Orders2ViewController: UIViewController {
    var goToOrders3button: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Orders 2"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        configureButton()
    }
    
    private func configureButton() {
        goToOrders3button = UIButton()
        view.addSubview(goToOrders3button)
        goToOrders3button.translatesAutoresizingMaskIntoConstraints = false
        
        goToOrders3button.setTitle(" Go to Orders 3 ", for: .normal)
        goToOrders3button.layer.borderColor = UIColor.black.cgColor
        goToOrders3button.layer.borderWidth = 2
        goToOrders3button.backgroundColor = .black
        goToOrders3button.addTarget(self, action: #selector(goToOrders3Screen), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            goToOrders3button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToOrders3button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func goToOrders3Screen() {
		openFlow(AppFlow.orders(.thirdScreen).boxed, sender: self)
    }
}
