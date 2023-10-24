import UIKit
import Lottie

class OnboardingVC: BaseVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    // MARK: - Public properties
    
    var viewModel: OnboardingVM?
    var id: String?
    var animationName: String?
    var titleText: String?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.onViewWillAppear(id: self.id ?? "")
        self.animationView?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.animationView?.stop()
    }
    
    private func initUI() {
        self.titleLabel.text = titleText
        self.animationView.animation = Animation.named(self.animationName ?? "")
        self.animationView?.contentMode = .scaleAspectFit
        self.animationView?.loopMode = .loop
        self.animationView?.backgroundBehavior = .pauseAndRestore
        Utils.styleFilledButton(self.startButton)
    }
    
    // MARK: - Actions
    
    @IBAction func onStartTap(_ sender: Any) {
        self.viewModel?.onStartTapped()
    }
}

// MARK: - OnboardingVMOutput

extension OnboardingVC: OnboardingVMOutput {
    
    func updateButtonStatus(show: Bool) {
        self.startButton.isHidden = !show
    }
}

