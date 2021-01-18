class ModalAction<T> {
  ModalAction({this.value, this.index = 0, this.actionType});
  T value;
  int index;
  ActionType actionType;
}

enum ActionType { create, update, destroy }
