import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  // Amiri Bold - Static TTF
  final url = 'https://raw.githubusercontent.com/google/fonts/main/ofl/amiri/Amiri-Bold.ttf';
  final file = File('assets/fonts/Amiri-Bold.ttf');
  
  try {
    print('Downloading font from $url...');
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      await file.parent.create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);
      print('SUCCESS: Font downloaded to ${file.path}');
      print('Size: ${response.bodyBytes.length} bytes');
    } else {
      print('Failed to download font: ${response.statusCode}');
      exit(1);
    }
  } catch (e) {
    print('Error downloading font: $e');
    exit(1);
  }
}
