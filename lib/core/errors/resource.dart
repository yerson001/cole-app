abstract class Resource<T> {}

class InitialResource extends Resource {}

class LoadingResource extends Resource {}

class SuccessResource<T> extends Resource<T> {
  final T data;
  SuccessResource(this.data);
}

class ErrorResource<T> extends Resource<T> {
  final String message;
  ErrorResource(this.message);
}
