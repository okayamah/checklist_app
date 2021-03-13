import 'package:checklist_app/entity/checklist.dart';

class TodoListViewModel {
  List<ChecklistInfo> checklist;

  TodoListViewModel({
    this.checklist,
  });

  TodoListViewModel.init() {
    checklist = new List<ChecklistInfo>();
  }
}
class ChecklistInfo {
  Checklist check;
  bool status;

  ChecklistInfo({
    this.check,
    this.status
  });
}
