import 'dart:convert';

import 'package:http/http.dart';

class CountryAPI {
  Future<List<Map>> getCountries() async {
    List<Map> countries = [];
    Uri url = Uri.https('freetestapi.com', 'api/v1/countries');
    final res = await get(url).onError((error, stackTrace) {
      return Response(
        {
          'status': 'failure',
          'error': error.toString(),
        }.toString(),
        404,
      );
    });
    if (res.statusCode == 200) {
      countries = (json.decode(res.body) as List)
          .map((country) => {
                'id': country['id'],
                'name': country['name'],
                'flag': country['flag'],
              })
          .toList();
    }
    return countries;
  }
}
