import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/env_config.dart';

/// GrokAIService - AI-powered symptom checker and health assistant
/// Uses Grok API for intelligent health analysis
class GrokAIService {
  static const String _baseUrl = 'https://api.x.ai/v1';
  
  // Get API key from environment config (NOT hardcoded)
  String get _apiKey => EnvConfig.grokApiKey;
  
  /// Analyze symptoms and provide health guidance
  Future<SymptomAnalysisResult> analyzeSymptoms({
    required List<String> symptoms,
    String? additionalInfo,
    int? age,
    String? gender,
    List<String>? existingConditions,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Grok API key not configured');
    }

    final prompt = _buildSymptomPrompt(
      symptoms: symptoms,
      additionalInfo: additionalInfo,
      age: age,
      gender: gender,
      existingConditions: existingConditions,
    );

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'grok-beta',
          'messages': [
            {
              'role': 'system',
              'content': _systemPrompt,
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.3,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return _parseAnalysisResponse(content);
      } else {
        debugPrint('Grok API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to analyze symptoms');
      }
    } catch (e) {
      debugPrint('Grok API error: $e');
      rethrow;
    }
  }

  /// Get medicine information
  Future<String> getMedicineInfo(String medicineName) async {
    if (_apiKey.isEmpty) {
      throw Exception('Grok API key not configured');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'grok-beta',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful medical assistant. Provide accurate information about medicines in Bangladesh. Include generic name, uses, dosage guidelines, side effects, and precautions. Always recommend consulting a doctor before taking any medicine.',
            },
            {
              'role': 'user',
              'content': 'Tell me about the medicine: $medicineName',
            },
          ],
          'temperature': 0.2,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get medicine info');
      }
    } catch (e) {
      debugPrint('Grok API error: $e');
      rethrow;
    }
  }

  /// General health chat assistant
  Future<String> chat(String message, {List<Map<String, String>>? history}) async {
    if (_apiKey.isEmpty) {
      throw Exception('Grok API key not configured');
    }

    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': 'You are MediNexus AI, a helpful healthcare assistant in Bangladesh. You provide general health information and guidance. Always recommend consulting a qualified healthcare professional for medical advice. Be empathetic and supportive.',
      },
      if (history != null) ...history,
      {
        'role': 'user',
        'content': message,
      },
    ];

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'grok-beta',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get response');
      }
    } catch (e) {
      debugPrint('Grok API error: $e');
      rethrow;
    }
  }

  String get _systemPrompt => '''
You are MediNexus AI, a medical symptom analysis assistant for healthcare in Bangladesh.
Your role is to help patients understand their symptoms and provide guidance.

IMPORTANT GUIDELINES:
1. You are NOT a doctor and cannot diagnose or prescribe treatment
2. Always recommend consulting a qualified healthcare professional
3. For emergencies, immediately advise going to the nearest hospital
4. Be empathetic and supportive
5. Provide information in simple, easy-to-understand language
6. Consider common conditions in Bangladesh context
7. Format your response as JSON with the following structure:
{
  "urgency": "low|medium|high|emergency",
  "possibleConditions": ["condition1", "condition2"],
  "recommendation": "brief recommendation text",
  "specialization": "recommended doctor specialization",
  "immediateActions": ["action1", "action2"],
  "warning": "any important warning or null"
}
''';

  String _buildSymptomPrompt({
    required List<String> symptoms,
    String? additionalInfo,
    int? age,
    String? gender,
    List<String>? existingConditions,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('PATIENT INFORMATION:');
    if (age != null) buffer.writeln('- Age: $age years');
    if (gender != null) buffer.writeln('- Gender: $gender');
    if (existingConditions != null && existingConditions.isNotEmpty) {
      buffer.writeln('- Existing conditions: ${existingConditions.join(", ")}');
    }
    
    buffer.writeln('\nSYMPTOMS:');
    for (final symptom in symptoms) {
      buffer.writeln('- $symptom');
    }
    
    if (additionalInfo != null && additionalInfo.isNotEmpty) {
      buffer.writeln('\nADDITIONAL INFORMATION:');
      buffer.writeln(additionalInfo);
    }
    
    buffer.writeln('\nPlease analyze these symptoms and provide guidance.');
    
    return buffer.toString();
  }

  SymptomAnalysisResult _parseAnalysisResponse(String content) {
    try {
      // Try to extract JSON from the response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch != null) {
        final json = jsonDecode(jsonMatch.group(0)!);
        return SymptomAnalysisResult(
          urgency: json['urgency'] ?? 'low',
          possibleConditions: json['possibleConditions'] != null
              ? List<String>.from(json['possibleConditions'])
              : [],
          recommendation: json['recommendation'] ?? content,
          specialization: json['specialization'],
          immediateActions: json['immediateActions'] != null
              ? List<String>.from(json['immediateActions'])
              : [],
          warning: json['warning'],
          rawResponse: content,
        );
      }
    } catch (e) {
      debugPrint('Failed to parse JSON response: $e');
    }
    
    // Fallback if JSON parsing fails
    return SymptomAnalysisResult(
      urgency: 'medium',
      possibleConditions: [],
      recommendation: content,
      rawResponse: content,
    );
  }
}

/// Result of symptom analysis
class SymptomAnalysisResult {
  final String urgency;
  final List<String> possibleConditions;
  final String recommendation;
  final String? specialization;
  final List<String> immediateActions;
  final String? warning;
  final String rawResponse;

  SymptomAnalysisResult({
    required this.urgency,
    required this.possibleConditions,
    required this.recommendation,
    this.specialization,
    this.immediateActions = const [],
    this.warning,
    required this.rawResponse,
  });

  bool get isEmergency => urgency == 'emergency';
  bool get isHighUrgency => urgency == 'high' || urgency == 'emergency';

  Map<String, dynamic> toJson() {
    return {
      'urgency': urgency,
      'possibleConditions': possibleConditions,
      'recommendation': recommendation,
      'specialization': specialization,
      'immediateActions': immediateActions,
      'warning': warning,
    };
  }
}
