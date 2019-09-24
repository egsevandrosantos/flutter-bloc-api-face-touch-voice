import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_project_bloc/src/constants/command.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentListBloc {
  List<Map<String, dynamic>> _establishments = List<Map<String, dynamic>>();
  SpeechRecognition _speechRecognition = SpeechRecognition();
  FlutterTts _flutterTts = FlutterTts();
  bool _isAvailable = false;
  bool _isListening = false;

  List<Map<String, dynamic>> get establishments => _establishments;

  void launchMapsUrl(String endereco) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$endereco';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchCall(String phone) async {
    final tel = "tel:$phone";
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      throw 'Could not tel $phone';
    }
  }

  void launchSMS(String phone) async {
    final sms = "sms:$phone";
    if (await canLaunch(sms)) {
      await launch(sms);
    } else {
      throw 'Could not sms $phone';
    }
  }

  void initializeList() async {
    Map<String, dynamic> fi = Map<String, dynamic>();
    fi['nome'] = 'FI Sistemas';
    fi['endereco'] = 'Av. José Ferrari Secondo, 521 - antigo 720 - Jardim Vale das Rosas, Araraquara - SP, 14806-053';
    fi['phone'] = '(16) 3331-6555';
    _establishments.add(fi);

    Map<String, dynamic> espaco = Map<String, dynamic>();
    espaco['nome'] = 'Espaço Café Araraquara';
    espaco['endereco'] = 'R. José do Amaral Velosa, 308 - Vila Velosa, Araraquara - SP, 14806-035';
    espaco['phone'] = '(16) 3331-6555';
    _establishments.add(espaco);
  }

  void initSpeechRecognizer() {
    _speechRecognition.setRecognitionStartedHandler(() => _isListening = true);

    _speechRecognition.setRecognitionResultHandler((String speech) {
      if (!_isListening)
        executeCommand(speech);
    });

    _speechRecognition.setRecognitionCompleteHandler(() => _isListening = false);

    _speechRecognition.activate().then((result) => _isAvailable = result);
  }

  void record() async {
    if (_isAvailable && !_isListening) {
      await _speechRecognition.listen(locale: "en_US");
    }
  }

  void executeCommand(String command) {
    if (command.toLowerCase().contains(Command.LOCALIZAR)) {
      launchMapsUrl(getEstablishment(command, Command.LOCALIZAR, 'nome')['endereco']);
    } else if (command.toLowerCase().contains(Command.LIGAR_PARA)) {
      launchCall(getEstablishment(command, Command.LIGAR_PARA, 'nome')['phone']);
    } else if (command.toLowerCase().contains(Command.SMS_PARA)) {
      launchSMS(getEstablishment(command, Command.SMS_PARA, 'nome')['phone']);
    } else {
      _speak("Não entendi");
    }
  }

  Map<String, dynamic> getEstablishment(String command, String keyword, String findBy) {
    String establishment = command.toLowerCase().replaceAll(keyword, "").trim();
    Map<String, dynamic> establishmentMap = establishments.firstWhere((e) => e[findBy].toString().toLowerCase() == establishment);
    return establishmentMap;
  }

  Future _speak(String textToSpeak) async{
    await _flutterTts.speak(textToSpeak);
  }
}