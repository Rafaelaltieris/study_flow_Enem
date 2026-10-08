import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/questao_enem.dart';

class EnemService {
  Future<List<QuestaoEnem>> buscarQuestoes({int ano = 2020}) async {
    final uri = Uri.https('api.enem.dev', '/v1/exams/$ano/questions', {
      'limit': '10',
      'offset': '0',
    });

    final resposta = await http.get(uri).timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 200) {
      throw Exception('A API respondeu com status ${resposta.statusCode}.');
    }

    final dados =
        jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;

    final itens = dados['questions'] as List<dynamic>;

    return itens
        .map((item) => QuestaoEnem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
