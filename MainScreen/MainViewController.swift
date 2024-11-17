import UIKit

class MainViewController: UIViewController {
    private let viewModel = TaskViewModel()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        
        // Настройка текстового поля
        let textField = searchBar.searchTextField
        textField.textColor = .white
        textField.tintColor = .white
        textField.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1.0)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        // Настройка цвета placeholder
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Цвет текста
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
        
        // Настройка лупы (иконки внутри текстового поля)
        if let leftIconView = textField.leftView as? UIImageView {
            leftIconView.image = leftIconView.image?.withRenderingMode(.alwaysTemplate) // Делаем лупу редактируемой
            leftIconView.tintColor = .white // Устанавливаем белый цвет для лупы
        }
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        return tableView
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.text = "7 Задач"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    private let homeBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установка тайтла
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Настройка внешнего вида navigationBar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        // Устанавливаем отступ для largeTitle
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        tableView.rowHeight = 106
        tableView.estimatedRowHeight = 106
        
        view.backgroundColor = .black
        setupLayout()
        setupTableView()
        loadTasks()
    }
    
    
    private func setupLayout() {
        // Добавляем все элементы на экран
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(homeBarBackgroundView)
        view.addSubview(footerView)
        footerView.addSubview(tasksCountLabel)
        footerView.addSubview(addTaskButton)
        
        // Отключаем автогенерацию ограничений
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        tasksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        homeBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Задаем ограничения
        NSLayoutConstraint.activate([
            // Поисковая строка
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            
            // Таблица
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Нижняя панель
            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 49),
            
            homeBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeBarBackgroundView.topAnchor.constraint(equalTo: footerView.bottomAnchor),
            homeBarBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Метка задач
            tasksCountLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            tasksCountLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            
            // Кнопка добавления задачи
            addTaskButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadTasks() {
        viewModel.fetchTasks { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = viewModel.tasks[indexPath.row]
        cell.configure(with: task)
        
        // Обрабатываем изменение статуса задачи
        cell.onStatusToggle = { [weak self] updatedTask in
            guard let self = self else { return }
            self.viewModel.updateTask(updatedTask)
            
            cell.configure(with: updatedTask)
        }
        return cell
    }
}
