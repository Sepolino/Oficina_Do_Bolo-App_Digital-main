import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'https://api.adviceslip.com/advice';

  Future<String> fetchBakingTip() async {
    try {
      final uri = Uri.parse(_baseUrl);
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return 'Não foi possível carregar a dica no momento.';
      }

      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      final slip = jsonBody['slip'] as Map<String, dynamic>?;
      final advice = slip?['advice']?.toString();

      if (advice == null || advice.isEmpty) {
        return 'Dica não encontrada. Tente novamente.';
      }

      return await _translateToPortuguese(advice);
    } catch (_) {
      return 'Erro ao buscar dica. Verifique sua conexão.';
    }
  }

  Future<String> _translateToPortuguese(String text) async {
    try {
      final translateUri = Uri.https(
        'api.mymemory.translated.net',
        '/get',
        {
          'q': text,
          'langpair': 'en|pt-BR',
        },
      );

      final response = await http.get(translateUri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return text;
      }

      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      final responseData = jsonBody['responseData'] as Map<String, dynamic>?;
      final translatedText = responseData?['translatedText']?.toString();

      return translatedText?.isNotEmpty == true ? translatedText! : text;
    } catch (_) {
      return text;
    }
  }
}
