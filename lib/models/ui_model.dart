class UIModel<T> {
  final OperationState state;
  final T? data;
  final Object? error;

  UIModel(
    this.state,
    this.data,
    this.error,
  );

  UIModel copyWith({
    OperationState? state,
    T? data,
    Object? error,
  }) {
    return UIModel(
      state ?? this.state,
      data ?? this.data,
      error ?? this.state,
    );
  }

  factory UIModel.success(T data) {
    return UIModel(OperationState.success, data, null);
  }

  UIModel<T> loading() {
    return UIModel(OperationState.loading, null, null);
  }

  factory UIModel.loading() {
    return UIModel(OperationState.loading, null, null);
  }

  factory UIModel.error(Object error, {T? data}) {
    return UIModel(OperationState.error, data, error);
  }

  UIModel<S> map<S>(S Function(T elem) f) {
    switch (state) {
      case OperationState.loading:
        return UIModel.loading();
      case OperationState.success:
        return UIModel.success(f(data!));
      case OperationState.error:
        return UIModel.error(error!, data: f(data!));
      default:
        return UIModel.loading();
    }
  }

  bool get isSuccess => state == OperationState.success;

  bool get isLoading => state == OperationState.loading;

  bool get isError => state == OperationState.error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UIModel &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          data == other.data &&
          error == other.error;

  @override
  int get hashCode => state.hashCode ^ data.hashCode ^ error.hashCode;
}

enum OperationState { loading, error, success }
