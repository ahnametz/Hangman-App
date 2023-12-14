import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  final Uri url;

  NetworkService(this.url);

  Future getData() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data[0].toString();
      } else {
        throw Exception('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}

class WordService {
  Future<String> getWordByLength(int wordLength) async {
    Uri url = Uri(
      scheme: 'https',
      host: 'random-word-api.herokuapp.com',
      path: '/word',
      queryParameters: {
        'number': '1',
        'length': '$wordLength',
      },
    );

    print('url: $url');
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    return data;
  }
}
