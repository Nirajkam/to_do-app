
class Tasks {
  String title;
  String description;
  bool isdone = false;

  Tasks({required this.title, required this.description});
}

class TaskManager {
  static List<Tasks> tasks = [];

  static void addtask(Tasks task) {
    tasks.add(task);
  }

  static void updateTask(int index, Tasks newTask) {
    tasks[index] = newTask;
  }

  static void deleteTask(int index) {
    tasks.removeAt(index);
  }
}
