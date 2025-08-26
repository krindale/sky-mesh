import 'package:flutter_test/flutter_test.dart';
import 'package:sky_mesh/services/location_image_service.dart';

void main() {
  group('New Cities Tests', () {
    test('Delhi should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'Delhi',
        countryCode: 'IN',
        weatherDescription: 'clear sky',
      );

      expect(imagePath, contains('delhi_sunny'));
      expect(imagePath, contains('asia'));
    });

    test('Osaka should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'Osaka',
        countryCode: 'JP',
        weatherDescription: 'rain',
      );

      expect(imagePath, contains('osaka_rainy'));
      expect(imagePath, contains('asia'));
    });

    test('Madrid should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'Madrid',
        countryCode: 'ES',
        weatherDescription: 'broken clouds',
      );

      expect(imagePath, contains('madrid_cloudy'));
      expect(imagePath, contains('europe'));
    });

    test('Milan should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'Milan',
        countryCode: 'IT',
        weatherDescription: 'snow',
      );

      expect(imagePath, contains('milan_snowy'));
      expect(imagePath, contains('europe'));
    });

    test('Montreal should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'Montreal',
        countryCode: 'CA',
        weatherDescription: 'foggy',
      );

      expect(imagePath, contains('montreal_foggy'));
      expect(imagePath, contains('north_america'));
    });

    test('Bogota should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'Bogota',
        countryCode: 'CO',
        weatherDescription: 'thunderstorm',
      );

      expect(imagePath, contains('bogota_rainy'));
      expect(imagePath, contains('south_america'));
    });

    test('Cape Town should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'cape_town',
        countryCode: 'ZA',
        weatherDescription: 'mist',
      );

      expect(imagePath, contains('cape_town_foggy'));
      expect(imagePath, contains('africa'));
    });

    test('Doha should return correct image path', () {
      final imagePath = LocationImageService.selectBackgroundImage(
        cityName: 'Doha',
        countryCode: 'QA',
        weatherDescription: 'clear sky',
      );

      expect(imagePath, contains('doha_sunny'));
      expect(imagePath, contains('middle_east'));
    });

    test('All new cities should be in supported cities list', () {
      final supportedCities = LocationImageService.getAllSupportedCities();
      
      expect(supportedCities, contains('delhi'));
      expect(supportedCities, contains('osaka'));
      expect(supportedCities, contains('madrid'));
      expect(supportedCities, contains('milan'));
      expect(supportedCities, contains('montreal'));
      expect(supportedCities, contains('bogota'));
      expect(supportedCities, contains('cape_town'));
      expect(supportedCities, contains('doha'));
    });

    test('Country mappings should include new cities', () {
      expect(LocationImageService.getCitiesForCountry('IN'), contains('delhi'));
      expect(LocationImageService.getCitiesForCountry('JP'), contains('osaka'));
      expect(LocationImageService.getCitiesForCountry('ES'), contains('madrid'));
      expect(LocationImageService.getCitiesForCountry('IT'), contains('milan'));
      expect(LocationImageService.getCitiesForCountry('CA'), contains('montreal'));
      expect(LocationImageService.getCitiesForCountry('CO'), contains('bogota'));
      expect(LocationImageService.getCitiesForCountry('ZA'), contains('cape_town'));
      expect(LocationImageService.getCitiesForCountry('QA'), contains('doha'));
    });
  });
}