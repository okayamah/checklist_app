import 'package:checklist_app/entity/task.dart';

class ItemListViewModel {
  List<ItemInfo> taskInfoList;

  ItemListViewModel({
    this.taskInfoList,
  });

  ItemListViewModel.init() {
    taskInfoList = new List<ItemInfo>();
  }
}
class ItemInfo {
  Task task;
  bool isSelected;

  ItemInfo({
    this.task,
    this.isSelected
  });
}
