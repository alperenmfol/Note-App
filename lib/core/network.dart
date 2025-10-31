import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternetConnection() async {
  //internet kontrolu
  final connectivityResults = await Connectivity().checkConnectivity();
  return !connectivityResults.contains(ConnectivityResult.none);
}
