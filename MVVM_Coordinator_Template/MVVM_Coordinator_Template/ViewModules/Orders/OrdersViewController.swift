import UIKit

class OrdersViewController: UIViewController {
    var goToOrders2button: UIButton!
    

	init() {
		super.init(nibName: nil, bundle: nil)
		title = "Orders"
	}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        configureButton()
    }
    
    private func configureButton() {
        goToOrders2button = UIButton()
        view.addSubview(goToOrders2button)
        goToOrders2button.translatesAutoresizingMaskIntoConstraints = false
        
        goToOrders2button.setTitle(" Go to Orders 2 ", for: .normal)
        goToOrders2button.layer.borderColor = UIColor.black.cgColor
        goToOrders2button.layer.borderWidth = 2
        goToOrders2button.backgroundColor = .black
        goToOrders2button.addTarget(self, action: #selector(goToOrders2), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            goToOrders2button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToOrders2button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func goToOrders2() {
		openFlow(AppFlow.orders(.secondScreen).boxed, sender: self)
    }
}
