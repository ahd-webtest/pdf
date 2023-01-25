/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:test/test.dart';

import 'utils.dart';

late Document pdf;

void main() {
  setUpAll(() {
    Document.debug = true;
    RichText.debug = true;
    pdf = Document();
  });

  test('Container Widgets Flat', () {
    pdf.addPage(Page(
      build: (Context context) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: PdfColors.blue,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: PdfColors.blue800,
              width: 2,
            )),
        width: 200,
        height: 400,
        // child: Placeholder(),
      ),
    ));
  });

  test('Container Widgets Image', () {
    final image = generateBitmap(100, 200);

    final widgets = <Widget>[];
    for (final shape in BoxShape.values) {
      for (final fit in BoxFit.values) {
        widgets.add(
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(image: image, fit: fit),
            ),
            width: 100,
            height: 100,
            child: Container(
              width: 70,
              color: PdfColors.yellow,
              child: Text(
                '$fit\n$shape',
                textAlign: TextAlign.center,
                textScaleFactor: 0.6,
              ),
            ),
          ),
        );
      }
    }

    pdf.addPage(MultiPage(
        build: (Context context) => <Widget>[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widgets,
              )
            ]));
  });

  test('Container Widgets BoxShape Border', () {
    pdf.addPage(Page(
      build: (Context context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: PdfColors.blue, width: 3),
              ),
            ),
            Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: PdfColors.blue, width: 3),
              ),
            ),
          ],
        ),
      ),
    ));
  });

  test('Container Widgets LinearGradient', () {
    pdf.addPage(Page(
      build: (Context context) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: const LinearGradient(
              colors: <PdfColor>[
                PdfColors.blue,
                PdfColors.red,
                PdfColors.yellow,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: <double>[0, .8, 1.0],
              tileMode: TileMode.clamp,
            ),
            border: Border.all(
              color: PdfColors.blue800,
              width: 2,
            )),
        width: 200,
        height: 400,
      ),
    ));
  });

  test('Container Widgets RadialGradient', () {
    pdf.addPage(Page(
      build: (Context context) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: const RadialGradient(
              colors: <PdfColor>[
                PdfColors.blue,
                PdfColors.red,
                PdfColors.yellow,
              ],
              stops: <double>[0.0, .2, 1.0],
              center: FractionalOffset(.7, .2),
              focal: FractionalOffset(.7, .45),
              focalRadius: 1,
            ),
            border: Border.all(
              color: PdfColors.blue800,
              width: 2,
            )),
        width: 200,
        height: 400,
        // child: Placeholder(),
      ),
    ));
  });

  test('Container Widgets BoxShadow Rectangle', () {
    pdf.addPage(Page(
      build: (Context context) => Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 10,
              offset: PdfPoint(2, 2),
            ),
          ],
          color: PdfColors.blue,
        ),
        width: 200,
        height: 400,
      ),
    ));
  });

  test('Container Widgets BoxShadow Ellipse', () {
    pdf.addPage(Page(
      build: (Context context) => Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 10,
              offset: PdfPoint(2, 2),
            ),
          ],
          color: PdfColors.blue,
        ),
        width: 200,
        height: 200,
      ),
    ));
  });

  tearDownAll(() async {
    final file = File('widgets-container.pdf');
    await file.writeAsBytes(await pdf.save());
  });
}
