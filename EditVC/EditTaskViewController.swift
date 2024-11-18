import UIKit

final class EditTaskViewController: UIViewController {
    var task: TaskModel?
    var onSave: ((TaskModel) -> Void)?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .white
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.isUserInteractionEnabled = true
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 16
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.layer.cornerRadius = 10
        textView.textAlignment = .left
        textView.isSelectable = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextField, dateLabel, descriptionTextView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupNavigationBar()
        setupLayout()
        configureView()
        
        titleTextField.delegate = self
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Назад", for: .normal)
        backButton.setTitleColor(.yellow, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        let arrowImage = UIImage(named: "Chevron")
        backButton.setImage(arrowImage, for: .normal)
        backButton.tintColor = .yellow
        
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 6)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        
        backButton.titleLabel?.lineBreakMode = .byClipping
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.titleLabel?.minimumScaleFactor = 0.8
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let customBackButtonContainer = UIView()
        customBackButtonContainer.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: customBackButtonContainer.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: customBackButtonContainer.trailingAnchor),
            backButton.topAnchor.constraint(equalTo: customBackButtonContainer.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: customBackButtonContainer.bottomAnchor)
        ])
        
        let customBackButton = UIBarButtonItem(customView: customBackButtonContainer)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -8
        
        navigationItem.leftBarButtonItems = [spacer, customBackButton]
    }
    
    
    private func setupLayout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.setCustomSpacing(8, after: titleTextField)
        stackView.setCustomSpacing(16, after: dateLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -18),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func configureView() {
        guard let task = task else { return }
        
        titleTextField.text = task.title
        dateLabel.text = task.date
        descriptionTextView.text = task.description
    }
    
    @objc private func backButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        guard let description = descriptionTextView.text else { return }
        
        if var updatedTask = task {
            updatedTask.title = title
            updatedTask.description = description
            onSave?(updatedTask)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension EditTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
