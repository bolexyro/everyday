class DataState<T> {
  const DataState(
    this.data,
    this.exceptionMessage,
  );
  final T? data;
  final String? exceptionMessage;
}
