import 'package:task_app/token_source.dart';

abstract class HeaderProvider {
  Map<String, String> call();
}

class HeaderProviderImpl implements HeaderProvider {
  @override
  Map<String, String> call() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }
}

class AuthHeaderProvider extends HeaderProviderImpl {
  final TokenSource _tokenSource;

  AuthHeaderProvider(this._tokenSource);
  @override
  Map<String, String> call() {
    return Map.from(super.call())
      ..putIfAbsent(
          "Authorization", () => "Bearer" + " " + _tokenSource.getToken());
  }
}
