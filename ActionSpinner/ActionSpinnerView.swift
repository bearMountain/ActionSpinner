




import Foundation

class ActionSpinnerView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinner()
        setupLabel()
        setupAnimator()
        setupPanRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public
    var spinnerView: UIView? {
        didSet {
            raft.addSubview(spinnerView!)
            spinnerView?.center = CGPoint(x: raft.frame.size.width/2.0, y: raft.frame.size.height/2.0)
        }
    }
    
    //MARK: - Private
    let raft = UIView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
    var animator: UIDynamicAnimator?
    var offset: CGPoint = CGPoint(x: 0, y: 0)
    var gravityBehavior = UIGravityBehavior()
    var itemBehavior = UIDynamicItemBehavior()
    var collisionBehavior = UICollisionBehavior()
    var label = UILabel(frame: CGRect(x: 0, y: 80, width: 100, height: 40))
    
    lazy var radialGravity: UIFieldBehavior = {
        let viewCenter = self.center
        let radialGravity = UIFieldBehavior.fieldWithEvaluationBlock { (field, position, velocity, mass, charge, deltaTime) -> CGVector in
            let dx = viewCenter.x - position.x
            let dy = viewCenter.y - position.y
            let factor: CGFloat = 5.0
            return CGVector(dx:dx/factor, dy:dy/factor)
        }
        radialGravity.addItem(self.raft)
        return radialGravity
    }()
    
    func setupSpinner() {
        raft.center = center
        self.addSubview(raft)
    }
    
    func setupLabel() {
        label.text = "Toss Me"
        label.textAlignment = .Center
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textColor = .whiteColor()
        raft.addSubview(label)
    }
    
    func setupAnimator() {
        animator = UIDynamicAnimator(referenceView: self)
        gravityBehavior = UIGravityBehavior(items: [raft])
        
        collisionBehavior = UICollisionBehavior(items: [raft])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        itemBehavior = UIDynamicItemBehavior(items: [raft])
        itemBehavior.resistance = 8
        itemBehavior.elasticity = 1.1
        
        
        animator?.addBehavior(radialGravity)
        animator?.addBehavior(collisionBehavior)
        animator?.addBehavior(itemBehavior)
        //        animator?.setValue(true, forKey: "debugEnabled")
    }
    
    func setupPanRecognizer() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
        raft.addGestureRecognizer(panRecognizer)
    }
    
    func pan(pan: UIPanGestureRecognizer) {
        var location = pan.locationInView(self)
        
        switch pan.state {
        case .Began:
            let center = raft.center
            offset.x = location.x - center.x
            offset.y = location.y - center.y
            
            animator?.removeAllBehaviors()
            label.hidden = true
            
        case .Changed:
            let referenceBounds = self.bounds
            let referenceWidth = referenceBounds.width
            let referenceHeight = referenceBounds.height
            
            // Get item bounds.
            let itemBounds = raft.bounds
            let itemHalfWidth = itemBounds.width / 2.0
            let itemHalfHeight = itemBounds.height / 2.0
            
            // Apply the initial offset.
            location.x -= offset.x
            location.y -= offset.y
            
            // Bound the item position inside the reference view.
            location.x = max(itemHalfWidth, location.x)
            location.x = min(referenceWidth - itemHalfWidth, location.x)
            location.y = max(itemHalfHeight, location.y)
            location.y = min(referenceHeight - itemHalfHeight, location.y)
            
            raft.center = location
            
        case .Ended:
            let velocity = pan.velocityInView(self)
            
            animator?.addBehavior(radialGravity)
            animator?.addBehavior(itemBehavior)
            animator?.addBehavior(collisionBehavior)
            
            itemBehavior.addLinearVelocity(velocity, forItem: raft)
            
        default: break
        }
    }
}