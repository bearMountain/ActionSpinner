






import UIKit


class ViewController: UIViewController {
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255.0/255.0, green: 73/255.0, blue: 81/255.0, alpha: 1)
        setupSpinner()
        setupLabel()
    }
    
    func setupSpinner() {
        let spinnerView = ActionSpinnerView(frame: view.bounds)

        view.addSubview(spinnerView)
        
        let indicator = DGActivityIndicatorView(type: .TripleRings, tintColor: .whiteColor(), size: 60.0)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.startAnimating()
        spinnerView.spinnerView = indicator
    }
    
    func setupLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: view.frame.size.width, height: 50))
        label.text = "Processing Photos..."
        label.textAlignment = .Center
        label.font = UIFont(name: "Avenir-Heavy", size: 26)
        label.textColor = .whiteColor()
        view.addSubview(label)
    }

}

