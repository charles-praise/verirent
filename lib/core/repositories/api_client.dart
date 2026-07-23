class ApiClient {
  const ApiClient({required this.baseUrl, this.defaultValue});

  final String baseUrl;
  final String? defaultValue;

  Future<dynamic> post({String? baseUrl, Map<String, dynamic>? data}) async {
    return {};
  }
}
