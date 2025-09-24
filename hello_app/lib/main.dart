// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'dart:developer' as developer;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _text = "Press the mic and start speaking...";
//   double _confidence = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (val) {
//           if (kDebugMode) developer.log('Status: $val');
//         },
//         onError: (val) {
//           if (kDebugMode) developer.log('Error: $val');
//         },
//       );

//       if (available) {
//         setState(() => _isListening = true);

//         _speech.listen(
//           onResult: (val) {
//             setState(() {
//               _text = val.recognizedWords;
//               if (val.hasConfidenceRating && val.confidence > 0) {
//                 _confidence = val.confidence;
//               }
//             });
//           },
//           listenOptions: stt.SpeechListenOptions(
//             partialResults: true,                 // live updates
//             listenMode: stt.ListenMode.dictation, // keeps listening longer
//           ),
//           listenFor: const Duration(seconds: 60), // max listen duration
//           pauseFor: const Duration(seconds: 5),   // stop after 5s silence
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Voice Input")),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Confidence: ${(_confidence * 100).toStringAsFixed(1)}%",
//                 style: const TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 color: Colors.grey[200],
//                 child: Text(
//                   _text,
//                   style: const TextStyle(fontSize: 24, color: Colors.black),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               FloatingActionButton(
//                 onPressed: _listen,
//                 child: Icon(_isListening ? Icons.mic : Icons.mic_none),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoiceInputApp(),
    );
  }
}

class VoiceInputApp extends StatefulWidget {
  const VoiceInputApp({super.key});

  @override
  State<VoiceInputApp> createState() => _VoiceInputAppState();
}

class _VoiceInputAppState extends State<VoiceInputApp> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
 

  String? apiData; // null means not loaded yet

Future<void> fetchData() async {
  setState(() {
    apiData = null; // data is loading
  });

  var url = Uri.parse("http://10.0.2.2:3000/api/numbers");
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    setState(() {
      apiData = data.toString(); // update UI
    });
  } else {
    setState(() {
      apiData = "Error: ${response.statusCode}";
    });
  }
}



  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Start/stop listening
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            _controller.text = _text; // fill into TextField
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ASHA")),
      body: Padding(
        
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(width:40),
            ElevatedButton.icon(
              onPressed: _listen,
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              label: Text(_isListening ? "Stop Listening" : "Start Voice Input"),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(width:40),
            ElevatedButton.icon(
              onPressed: _listen,
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              label: Text(_isListening ? "Stop Listening" : "Start Voice Input"),
            ),
             const SizedBox(height: 20),
             apiData == null? const CircularProgressIndicator() : Text(apiData!, style: const TextStyle(fontSize: 18)),

          ],
        ),
      ),
    );
  }
}
