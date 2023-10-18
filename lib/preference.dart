import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

late StreamingSharedPreferences preferences;

Future initPreferences() async {
  preferences = await StreamingSharedPreferences.instance;
}