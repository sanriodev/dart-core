<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

## Features

Ready to go inheritable http client abstract to extend with your http client that implements JWT Token refreshing and retry policies out of the box.

Ready to go Authorization http Client for login/logout/refresh and getting the logged in User.

Get saved user and tokens from last login on app start, making login persistent across app-reloads.

## Getting started

> [!WARNING]  
> If you are using Hive, ensure you leave the HivetypeId 1 for the package!

First call the function `registerDartCore()` provided by the package:

```dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerDartCore();

  runApp(const MainAppScreen());
}

```

now you are ready to use the provided `AuthBackend()` for login, logout and refresh or implement your own Backend service with automatisch JWT Token injection and refresh interceptor.

## Using the provided Auth-Client for login and more in your Widgets

```dart
  Future<void> login(String username, String password) async {
    final authBackend = AuthBackend();
    try {
      await authBackend.postLogin(username, password);
      navigateToRoute(
        context,
        'home',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
      return;
    }
  }

   @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
              onPressed: () {
                login("user", "password")
              }
              icon: const Icon(Icons.login),
              label: const Text('Sign in'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                ),
            );
  }
```

## Implementing your own Client with the provided token refresh mechanism and access token injection

When `AuthBackend().login()` is called, and the user login is successfull, the logged in user with accessToken and refreshToken will automatically be saved to Hive.
When calling a request like `this.get()` from your client that extends the provided ABackend the accessToken of the logged in User will automatically be put into the `Authorization` header of the request.
When the request returns a `401` (unauthorized) status code, the Refresh Interceptor implemented in the ABackend will automatically try to refresh using the logged in Users refreshToken according to the TokenRetrypolicy. After a succesfull refresh it will automatically retry the failed request and the Future will complete succesfully.

If the refresh token is invalid or the refresh does not work otherwise it will throw a `SessionExpired` Exception.

```dart
class Backend extends ABackend {
  static final Backend _instance = Backend._privateConstructor();
  factory Backend() => _instance;
  Backend._privateConstructor() {
    super.init();
  }

  Future<List<dynamic>> getData() async {
    final res = await get('data-path/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as dynamic;
      return jsonData;
    } else {
      throw res;
    }
  }
}

```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
