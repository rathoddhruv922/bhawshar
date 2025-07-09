class LocationState {
  static final LocationState _instance = LocationState._internal();
  factory LocationState() => _instance;

  int? _myBool;

  int get myBool {
    _myBool ??= -1;
    return _myBool!;
  }

  set myBool(int value) {
    _myBool = value;
  }

  LocationState._internal();
}
