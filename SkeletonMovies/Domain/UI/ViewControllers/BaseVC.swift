//
//  BaseVC.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import UIKit

protocol BaseVCOutput {}

extension BaseVCOutput {}

protocol BaseVCInput {
    
    //MARK: Spinner
    func updateProgressSpinner(visible: Bool, autoDismiss: Bool)
}

class BaseVC: UIViewController {
    
    // MARK: - Public properties
    
    var output: BaseVCOutput?
    
    // MARK: - Private properties
    
    private var progressSpinner: ProgressSpinner?
    
    // MARK: - Life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createProgressSpinner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private methods
    
    private func createProgressSpinner() {
        self.progressSpinner = ProgressSpinner()
        self.progressSpinner?.createStructure(mainView: self.view)
    }
    
}

// MARK: - BaseVCInput

extension BaseVC: BaseVCInput {
    
    // ProgressBar
    func updateProgressSpinner(visible: Bool, autoDismiss: Bool = false) {
        self.progressSpinner?.updateVisibility(show: visible, autoDismiss: autoDismiss)
    }
    
    
}

