class DataState<T> {
  const DataState({
    this.data,
    this.exceptionMessage,
  });
  final T? data;
  final String? exceptionMessage;
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataException extends DataState {
  const DataException(String exception) : super(exceptionMessage: exception);
}
