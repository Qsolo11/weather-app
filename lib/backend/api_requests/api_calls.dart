import 'dart:convert';

import '/components/the_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetCurrentLocationForecaseCall {
  static Future<ApiCallResponse> call({
    String? q = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get Current Location Forecase',
      apiUrl: 'http://api.weatherapi.com/v1/current.json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "419870b595624ce6a98174044241002",
        'q': q,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static String? locationName(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.location.name''',
      ));
  static String? countryName(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.location.country''',
      ));
  static double? tempC(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.temp_c''',
      ));
  static int? isDay(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.current.is_day''',
      ));
  static String? condition(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.current.condition.text''',
      ));
  static double? windSpeed(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.wind_kph''',
      ));
  static double? humidity(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.humidity''',
      ));
  static double? cloud(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.cloud''',
      ));
  static double? feelsLike(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.feelslike_c''',
      ));
  static String? condiIcon(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.current.condition.icon''',
      ));
}

class GetCurrentLocationFiveDaysAheadCall {
  static Future<ApiCallResponse> call({
    String? q = '',
    String? days = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get Current Location five days ahead',
      apiUrl: 'http://api.weatherapi.com/v1/forecast.json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "419870b595624ce6a98174044241002",
        'q': q,
        'days': days,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static String? locationName(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.location.name''',
      ));
  static String? countryName(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.location.country''',
      ));
  static double? tempC(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.temp_c''',
      ));
  static int? isDay(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.current.is_day''',
      ));
  static String? condition(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.current.condition.text''',
      ));
  static double? windSpeed(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.wind_kph''',
      ));
  static double? humidity(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.humidity''',
      ));
  static double? cloud(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.cloud''',
      ));
  static double? feelsLike(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.feelslike_c''',
      ));
  static String? condiIcon(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.current.condition.icon''',
      ));
  static List? forecastDays(dynamic response) => getJsonField(
        response,
        r'''$.forecast.forecastday''',
        true,
      ) as List?;
}

class SearchCityAutoCompleteCall {
  static Future<ApiCallResponse> call({
    String? q = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Search City Auto Complete',
      apiUrl: 'http://api.weatherapi.com/v1/search.json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "419870b595624ce6a98174044241002",
        'q': q,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
