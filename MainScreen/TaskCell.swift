import UIKit

final class TaskCell: UITableViewCell {
    static let identifier = "TaskCell"
    
    private let statusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private var task: TaskModel?
    var onStatusToggle: ((TaskModel) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(statusButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        setupConstraints()
        statusButton.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            statusButton.widthAnchor.constraint(equalToConstant: 24),
            statusButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        statusButton.setImage(nil, for: .normal)
        
        titleLabel.text = nil
        titleLabel.attributedText = nil
        titleLabel.textColor = .white
        
        descriptionLabel.text = nil
        descriptionLabel.textColor = .white
        
        dateLabel.text = nil
        
        task = nil
    }
    
    func configure(with task: TaskModel) {
        self.task = task
        descriptionLabel.text = task.description
        dateLabel.text = task.date
        
        let imageName = task.isCompleted ? "done_icon" : "not_done_icon"
        statusButton.setImage(UIImage(named: imageName), for: .normal)
        
        if task.isCompleted {
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.darkGray
                ]
            )
            titleLabel.attributedText = attributedText
            titleLabel.textColor = .darkGray
            descriptionLabel.textColor = .darkGray
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = task.title
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
        }
    }
    
    @objc private func statusButtonTapped() {
        guard var task = task else { return }
        task.isCompleted.toggle()
        
        onStatusToggle?(task)
        
        configure(with: task)
    }
}
