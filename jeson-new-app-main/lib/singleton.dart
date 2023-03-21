class Singleton {
  static final Singleton _instance = Singleton._internal();

  // passes the instantiation to the _instance object
  factory Singleton() => _instance;

  // initialize our variables
  Singleton._internal() {
    _userData = null;
  }

  Map<String, dynamic>? _userData = null;
  String status = "viewing";

  // getter
  Map<String, dynamic>? get userData => _userData;

  // setter
  set userData(Map<String, dynamic>? value) => _userData = value;
}