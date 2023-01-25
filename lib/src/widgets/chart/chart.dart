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

import 'package:meta/meta.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../../pdf.dart';
import '../box_border.dart';
import '../container.dart';
import '../decoration.dart';
import '../flex.dart';
import '../geometry.dart';
import '../stack.dart';
import '../widget.dart';

/// This widget is in preview and the API is subject to change
class Chart extends Widget implements Inherited {
  Chart({
    required this.grid,
    required this.datasets,
    this.overlay,
    this.title,
    this.bottom,
    this.left,
    this.right,
  });

  /// The Coordinate system that will layout the content
  final ChartGrid grid;

  /// The list of dataset to display
  final List<Dataset> datasets;

  /// Legend for this chart
  final Widget? overlay;

  final Widget? title;

  final Widget? bottom;

  final Widget? left;

  final Widget? right;

  Context? _context;

  late Widget _child;

  static Chart of(Context context) => context.dependsOn<Chart>()!;

  PdfPoint _computeSize(BoxConstraints constraints) {
    if (constraints.isTight) {
      return constraints.smallest;
    }

    var width = constraints.maxWidth;
    var height = constraints.maxHeight;

    const aspectRatio = 1;

    if (!width.isFinite) {
      width = height * aspectRatio;
    }

    if (!height.isFinite) {
      height = width * aspectRatio;
    }

    return constraints.constrain(PdfPoint(width, height));
  }

  Widget _build(Context context) {
    return Column(
      children: <Widget>[
        if (title != null) title!,
        Expanded(
          child: Row(
            children: <Widget>[
              if (left != null) left!,
              Expanded(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    grid,
                    if (overlay != null) overlay!,
                  ],
                ),
              ),
              if (right != null) right!,
            ],
          ),
        ),
        if (bottom != null) bottom!,
      ],
    );
  }

  @override
  void layout(Context context, BoxConstraints constraints,
      {bool parentUsesSize = false}) {
    box = PdfRect.fromPoints(PdfPoint.zero, _computeSize(constraints));
    _context = context.inheritFrom(this);
    _child = _build(_context!);
    _child.layout(_context!, BoxConstraints.tight(box!.size));
  }

  @override
  void paint(Context context) {
    super.paint(_context!);

    final mat = Matrix4.identity();
    mat.translate(box!.x, box!.y);
    _context!.canvas
      ..saveContext()
      ..setTransform(mat);

    _child.paint(_context!);

    _context!.canvas.restoreContext();
  }
}

abstract class ChartGrid extends Widget {
  @override
  void layout(Context context, BoxConstraints constraints,
      {bool parentUsesSize = false}) {
    box = PdfRect.fromPoints(PdfPoint.zero, constraints.biggest);
  }

  PdfPoint toChart(PdfPoint p);
}

@immutable
abstract class ChartValue {
  const ChartValue();
}

abstract class Dataset extends Widget {
  Dataset({
    this.legend,
    this.color,
    this.borderColor,
    this.borderWidth = .5,
  });

  final String? legend;

  final PdfColor? color;

  final PdfColor? borderColor;

  final double borderWidth;

  void paintBackground(Context context) {}

  void paintForeground(Context context) {}

  Widget legendShape(Context context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: borderColor ?? PdfColors.black,
          width: borderWidth,
        ),
      ),
    );
  }
}
