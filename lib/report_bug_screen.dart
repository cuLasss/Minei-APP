import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  BugReportScreenState createState() => BugReportScreenState();
}

class BugReportScreenState extends State<ReportBugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatar um Bug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Encaminharemos você para um formulário dedicado a envio de bugs.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _launchBugReportForm();
              },
              child: const Text('Clique aqui para relatar um bug'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchBugReportForm() async {
    final Uri url = Uri.parse('https://docs.google.com/forms/d/1bYaXYZaxYAzTlJa1WkFKeHTSNk_ca6eyuGs1pijLmv0/edit?hl=pt-br&pli=1#responses');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      if (mounted) { // Verifica se o widget ainda está montado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Muito obrigado por avisar! Isso ajuda no desenvolvimento do App!'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      throw 'Não foi possível abrir o formulário!';
    }
  }
}