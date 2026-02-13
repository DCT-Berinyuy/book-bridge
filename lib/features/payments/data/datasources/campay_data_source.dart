import 'dart:convert';
import 'package:book_bridge/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

class CamPayDataSource {
  final String appId;
  final String appUsername;
  final String appPassword;
  final String baseUrl;

  CamPayDataSource({
    required this.appId,
    required this.appUsername,
    required this.appPassword,
    this.baseUrl = 'https://demo.campay.net/api', // Default to demo
  });

  /// Generates a temporary access token for CamPay API.
  Future<String> getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': appUsername, 'password': appPassword}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'] as String;
      } else {
        throw ServerException(
          message:
              'Failed to get CamPay token: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'CamPay Network Error: $e');
    }
  }

  /// Initiates a payment collection (Direct Pay).
  /// [amount]: Amount in XAF.
  /// [phoneNumber]: Student's phone number without +.
  /// [externalReference]: Reference to listing or donation (e.g. "boost:listing_id").
  Future<Map<String, dynamic>> collect({
    required int amount,
    required String phoneNumber,
    required String externalReference,
    String description = 'BookBridge Payment',
  }) async {
    final token = await getAccessToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/collect/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'amount': amount.toString(),
          'currency': 'XAF',
          'from': phoneNumber,
          'description': description,
          'external_reference': externalReference,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message:
              'CamPay Collection failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'CamPay Collection Error: $e');
    }
  }

  /// Checks the status of a transaction.
  Future<Map<String, dynamic>> getTransactionStatus(String reference) async {
    final token = await getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transaction/$reference/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message: 'CamPay Status Check failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'CamPay Status Check Error: $e');
    }
  }
}
