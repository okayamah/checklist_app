import 'package:checklist_app/entity/task.dart';

class ItemListViewModel {
  List<TaskInfo> taskInfoList;

  ItemListViewModel({
    this.taskInfoList,
  });

  ItemListViewModel.init() {
    taskInfoList = new List<TaskInfo>();
  }
}
class TaskInfo {
  Task task;
  bool isSelected;

  TaskInfo({
    this.task,
    this.isSelected
  });
}
