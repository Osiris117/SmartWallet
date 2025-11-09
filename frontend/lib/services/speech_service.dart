import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  
  bool _isInitialized = false;
  bool _isTtsInitialized = false;
  bool _isSpeaking = false;

  factory SpeechService() {
    return _instance;
  }

  SpeechService._internal();

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (error) => print('STT Error: $error'),
        onStatus: (status) => print('STT Status: $status'),
      );
    }
    
    if (!_isTtsInitialized) {
      await _initializeTts();
    }
    
    return _isInitialized;
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage("es-MX");
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      
      _tts.setStartHandler(() {
        _isSpeaking = true;
      });
      
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });
      
      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
        print('TTS Error: $msg');
      });
      
      _isTtsInitialized = true;
    } catch (e) {
      print('Error inicializando TTS: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isTtsInitialized) await _initializeTts();
    
    try {
      await _tts.speak(text);
    } catch (e) {
      print('Error al hablar: $e');
      _isSpeaking = false;
    }
  }

  Future<void> speakList(List<String> texts, {int pauseMs = 800}) async {
    for (String text in texts) {
      await speak(text);
      await Future.delayed(Duration(milliseconds: pauseMs));
    }
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  bool get isSpeaking => _isSpeaking;

  Future<void> startListening({
    required Function(String text) onResult,
    required Function() onComplete,
    String locale = 'es_MX',
  }) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) {
        print('No se pudo inicializar el reconocimiento de voz');
        onComplete();
        return;
      }
    }

    if (!_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            String recognizedText = result.recognizedWords.toLowerCase();
            print('Reconocido: $recognizedText');
            onResult(recognizedText);
            onComplete();
          }
        },
        localeId: locale,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }

  bool get isListening => _speech.isListening;

  String? detectCommand(String text) {
    text = text.toLowerCase().trim();
    
    if (text.contains('enviar') || text.contains('envío')) {
      return 'send';
    }
    if (text.contains('recibir') || text.contains('recibo')) {
      return 'receive';
    }
    if (text.contains('atrás') || text.contains('regresar') || text.contains('volver')) {
      return 'back';
    }
    if (text.contains('confirmar') || text.contains('aceptar') || text.contains('sí')) {
      return 'confirm';
    }
    if (text.contains('cancelar') || text.contains('no')) {
      return 'cancel';
    }
    if (text.contains('voz')) {
      return 'voice';
    }
    if (text.contains('señas') || text.contains('seña')) {
      return 'signs';
    }
    if (text.contains('iniciar') || text.contains('login')) {
      return 'login';
    }
    if (text.contains('crear') || text.contains('registro') || text.contains('cuenta')) {
      return 'register';
    }
    
    return null;
  }

  void dispose() {
    stopListening();
    stopSpeaking();
  }
}
