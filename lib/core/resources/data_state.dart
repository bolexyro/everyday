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

class DataException<T> extends DataState<T> {
  const DataException(String exceptionMessage)
      : super(exceptionMessage: exceptionMessage);
}

class DataSuccessWithException<T> extends DataState<T> {
  const DataSuccessWithException(T data, String exceptionMessage)
      : super(data: data, exceptionMessage: exceptionMessage);
}
