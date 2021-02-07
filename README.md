A minimalistic framework-agnostic library for showing info messages without
interrupting the overall flow on web applications.

## Usage

A simple usage example:

```dart
import 'package:toast/toast.dart';

main() {
  Toast(
    title: 'Info',
    text: 'Your changes has been saved!',
    duration: const Duration(seconds: 3));
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/afpatmin/toast/issues
