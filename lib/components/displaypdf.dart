import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class DisplayPdf extends StatefulWidget {
  final File file;
  DisplayPdf({Key key, this.file}) : super(key: key);

  @override
  State<DisplayPdf> createState() => _DisplayPdfState(this.file);
}

class _DisplayPdfState extends State<DisplayPdf> with WidgetsBindingObserver {
  final File file;
  int pages = 0;
  bool isReady;
  String errorMessage;
  int currentPage;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  _DisplayPdfState(this.file);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pdf file"),backgroundColor: Colors.deepPurple),
      body: Container(
        child: PDFView(
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
        ),
      ),
    );
  }
}
