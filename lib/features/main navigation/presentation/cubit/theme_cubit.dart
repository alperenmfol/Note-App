import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  Future<void> loadTheme() async {
    final box = await Hive.openBox('settings');
    final isDark = box.get('isDarkMode', defaultValue: false);
    emit(isDark);
  }

  Future<void> toggleTheme() async {
    final box = await Hive.openBox('settings');
    final newMode = !state;
    await box.put('isDarkMode', newMode);
    emit(newMode);
  }
}
