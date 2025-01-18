// // import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
//
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:typed_data';
//
// ///share Image format
// Future<void> shareFile(Uint8List image) async {
//   final bytes = image;
//   final temp = await getTemporaryDirectory();
//   final path = '${temp.path}/image.jpg';
//   final text = '';
//   File(path).writeAsBytesSync(bytes);
//   Share.shareXFiles([XFile(path)], text: text);
// }
// ///share pdf format
// Future<void> sharepdfFile(Uint8List fileData, ) async {
// // Future<void> sharepdfFile(File fileData, ) async {
//   // Uint8List pdfData = await fileData.readAsBytes();; // Convert to Uint8List
//   final temp = await getTemporaryDirectory();
//   String path;
//   if (fileData != null) {
//     path = '${temp.path}/document.pdf';
//     await File(path).writeAsBytes(fileData);
//   }  else {
//     throw Exception('Unsupported file type');
//   }
//   Share.shareXFiles([XFile(path)]);
// }
//
// ///to redirect url
// Future<void> launchURL( String url) async {
//   final Uri uri = Uri.parse(url);  // Parse the URL properly
//   if (await canLaunchUrl(uri)) {
//     try {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);  // Open in the browser
//     } catch (e) {
//       print('Could not launch $url: $e');
//     }
//   } else {
//     print('Invalid URL or no app available to handle the URL: $url');
//   }
// }
//
// Future<void> launchProfileURL(String profileUrl) async {
//   final Uri uri = Uri.parse(profileUrl);
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   } else {
//     print('Could not launch $profileUrl');
//   }
// }
// ///to redirect gmail
// Future<void> launchEmailApp(String email) async {
//   String subject = "";
//   String body = "";
//   final Uri params = Uri(
//     scheme: 'mailto',
//     path: email,
//     query: 'subject=$subject&body=$body', // Add subject and body here
//   );
//   final String url = params.toString();
//
//   if (await canLaunchUrl(Uri.parse(url))) {
//     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); // Opens Gmail or email client
//   } else {
//     print('Could not launch $url');
//   }
// }
// bool isLoading = false;
//
// Future<void> downloadPdf(String url, String fileName) async {
//   // setState(() {
//   //   isLoading = true;
//   // });
//
//   try {
//     // Get the directory to save the PDF file
//     var directory = await getApplicationDocumentsDirectory();
//     String filePath = '${directory.path}/$fileName';
//
//     // Download the file using Dio
//     Dio dio = Dio();
//     await dio.download(url, filePath);
//
//     // Open the downloaded PDF file
//     // OpenFilex.open(filePath);
//
//     // setState(() {
//     //   isLoading = false;
//     // });
//   } catch (e) {
//     print('Error downloading file: $e');
//     // setState(() {
//     //   isLoading = false;
//     // });
//   }
// }
