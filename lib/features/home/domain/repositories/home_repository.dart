import '../enitities/weather_entity.dart';

abstract class HomeRepository {
  Future<WeatherEntity> getWeather();
}