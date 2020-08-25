import 'dart:math';
import 'package:sqflite/sqflite.dart';

class CustomerBackendService {
  static Future<List> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
  }
}

class CustomerService {
  static final List<String> customer = [
    '1',
    'A2007081',
    'A2007082',
    'A2007083',
    'A2007084',
    'A2007085',
    'A2007086',
    'A2007087',
    'A2007088',
    'A2007089',
    'A2007090',
    'A2007091',
    'LDR400NP',
    'A10142053',
    'NLP52202031',
    'NNP73479',
    'NNP72278',
    'NNP73472',
    'NNP73478',
    'NNP74472',
    'NNP74478',
    'NNP74479',
    'NNP74578',
    '3115047',
    '303',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(customer);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
