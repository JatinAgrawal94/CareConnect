import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class DisplayPdf extends StatefulWidget {
  final File file;
  final String fileURL;
  DisplayPdf({Key key, this.file, this.fileURL}) : super(key: key);

  @override
  State<DisplayPdf> createState() => _DisplayPdfState(this.file, this.fileURL);
}

class _DisplayPdfState extends State<DisplayPdf> with WidgetsBindingObserver {
  final File file;
  final String fileURL;
  int pages = 0;
  bool isReady;
  String errorMessage;
  int currentPage;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  _DisplayPdfState(this.file, this.fileURL);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Pdf file"), backgroundColor: Colors.deepPurple),
      body: Container(
        child: fileURL == null
            ? PDFView(
                filePath: file.path,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: false,
                onRender: (_pages) {
                  setState(() {
                    pages = _pages;
                    isReady = true;
                  });
                },
                onError: (error) {
                  print(error.toString());
                },
                onPageError: (page, error) {
                  print('$page: ${error.toString()}');
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  _controller.complete(pdfViewController);
                },
                onPageChanged: (int page, int total) {
                  print('page change: $page/$total');
                },
              )
            : Container(child: Text("Downloading file")),
      ),
    );
  }
}
