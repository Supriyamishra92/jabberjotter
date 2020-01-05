import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(JabberJotterApp());

class JabberJotterApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JabberJotter v0.1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: JabberJotterHomePage(
        title: 'Welcome to JabberJotter.io'),
    );
  }
}

class JabberJotterHomePage extends StatefulWidget {
  JabberJotterHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JabberJotterHomePageState createState() => _JabberJotterHomePageState();
}

class _JabberJotterHomePageState extends State<JabberJotterHomePage> {

  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  @override
  void initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new Expanded(
                  child: new Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.grey.shade200,
                      child: new Text(transcription))),
              _buildButton(
                onPressed: _speechRecognitionAvailable && !_isListening
                    ? () => start()
                    : null,
                label: _isListening
                    ? 'Listening...'
                    : 'Listen',
              ),
              _buildButton(
                onPressed: _isListening ? () => cancel() : null,
                label: 'Cancel',
              ),
              _buildButton(
                onPressed: _isListening ? () => stop() : null,
                label: 'Stop',
              ),
            ],
          ),
        ));
  }

  void activateSpeechRecognizer() {
    _speech = SpeechRecognition();

    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onrRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);

    _speech.
    activate()
    .then((result)  => setState(() => _speechRecognitionAvailable = result));
  }

  void onSpeechAvailability(bool result) {
    setState(() => _speechRecognitionAvailable = result);
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onrRecognitionResult(String text) {
    setState(() => transcription = text);
  }

  void onRecognitionComplete() {
    setState(() => _isListening = false);
  }

  void start() {
    _speech.listen(locale: 'en_US');
  }

  void cancel() {
    _speech.cancel().then((result) => setState(() => _isListening = result));
  }

  void stop() => _speech.stop().then((result) {
    setState(() => _isListening = result);
  });
}

Widget _buildButton({Function() onPressed, String label}) => new Padding(
    padding: new EdgeInsets.all(12.0),
    child: new RaisedButton(
      color: Colors.cyan.shade600,
      onPressed: onPressed,
      child: new Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    ));

