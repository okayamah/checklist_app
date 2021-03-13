import 'package:checklist_app/entity/checklist.dart';
import 'package:checklist_app/entity/task.dart';

class TodoEditViewModel {
  Checklist checklist;
  List<TaskInfo> taskList;

  TodoEditViewModel({
    this.checklist,
    this.taskList,
  });

  TodoEditViewModel.init() {
    taskList = new List<TaskInfo>();
  }

  TodoEditViewModel.map(Map<String, String> map) {
    taskList = new List<TaskInfo>();
    map.forEach((key, value) { 
      Task task = new Task(title: key, category: value);
      TaskInfo taskInfo = new TaskInfo(task: task);
      taskList.add(taskInfo);
    });
  }
}
class TaskInfo {
  Task task;
  bool status;
  bool isNew;

  TaskInfo({
    this.task,
    this.status,
    this.isNew = false
  });
}
