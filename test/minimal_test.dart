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
import 'package:test/test.dart';

void main() {
  test('Pdf Minimal', () async {
    final pdf = PdfDocument(compress: false);
    final page = PdfPage(pdf, pageFormat: PdfPageFormat.a4);

    final g = page.getGraphics();
    g.drawLine(
        30, page.pageFormat.height - 30.0, 200, page.pageFormat.height - 200.0);
    g.strokePath();

    final file = File('minimal.pdf');
    await file.writeAsBytes(await pdf.save());
  });
}
