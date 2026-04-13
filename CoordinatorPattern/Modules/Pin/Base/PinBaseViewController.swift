//
//  PinBaseViewController.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 11/4/26.
//

import UIKit
import Combine
import SnapKit

class PinBaseViewController<ViewModel: PinBaseViewModel>: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    let viewModel: ViewModel
    
    //MARK: - UI Properties
    private let instructionLabel = UILabel()
    private let pinDotsView = PinDotsView()
    private let pinPadView = PinPadView()
    private let errorLabel = UILabel()
    
    //MARK: - Initializers
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        bindViewModel()
    }
    
}

//MARK: - SetupUI
private extension PinBaseViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        instructionLabel.font = .systemFont(ofSize: 20, weight: .bold)
        instructionLabel.textAlignment = .center
        
        errorLabel.font = .systemFont(ofSize: 14, weight: .regular)
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
    }
    
    func configureConstraints() {
        view.addSubview(instructionLabel)
        view.addSubview(pinDotsView)
        view.addSubview(errorLabel)
        view.addSubview(pinPadView)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        pinDotsView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(pinDotsView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        pinPadView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.height.equalTo(view.snp.height).multipliedBy(0.42)
        }
    }
}

//MARK: - VM Binding
private extension PinBaseViewController {
    func bindViewModel() {
        viewModel.$instructionText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.instructionLabel.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$enteredDigits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] digits in
                self?.pinDotsView.updateFilled(count: digits.count)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.errorLabel.text = message
                self?.errorLabel.isHidden = (message == nil)
                if message != nil {
                    self?.pinDotsView.shake()
                }
            }
            .store(in: &cancellables)
        
        pinPadView.digitTapped
            .sink { [weak self] digit in
                self?.viewModel.digitTapped(digit)
            }
            .store(in: &cancellables)
        
        pinPadView.backspaceTapped
            .sink { [weak self] in
                self?.viewModel.backspaceTapped()
            }
            .store(in: &cancellables)
    }
}
