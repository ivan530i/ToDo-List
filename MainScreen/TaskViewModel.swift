import Foundation

final class TaskViewModel {
    var tasks: [TaskModel] = []
    var filteredTasks: [TaskModel] = []
    
    func fetchTasks(completion: @escaping () -> Void) {
        tasks = [
            TaskModel(id: 1, title: "Почитать книгу", description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", date: "09/10/24", isCompleted: false),
            TaskModel(id: 2, title: "Уборка в квартире", description: "Провести генеральную уборку в квартире", date: "02/10/24", isCompleted: false),
            TaskModel(id: 3, title: "Заняться спортом", description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!", date: "02/10/24", isCompleted: false),
            TaskModel(id: 4, title: "Работа над проектом", description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач.", date: "09/10/24", isCompleted: false),
            TaskModel(id: 5, title: "Вечерний отдых", description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку", date: "02/10/24", isCompleted: false),
        ]
        filteredTasks = tasks
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func updateTask(_ updatedTask: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
        filterTasks(with: "")
    }
    
    func filterTasks(with query: String) {
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
}
