// Copyright (c) 2014, the Liquid project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Bad Example, for demonstration purposes only!

import 'dart:async';
import 'dart:html';
import 'package:vdom/vdom.dart' as v;
import 'package:vdom/helpers.dart' as vdom;
import 'package:liquid/liquid.dart';

class Collapsable extends VComponent<DivElement> {
  bool collapsed = false;
  List<v.Node> _collapsableChildren;

  Collapsable(Context context, this._collapsableChildren)
      : super(new DivElement(), context) {
    element.onClick.listen((_) {
      collapsed = true;
      invalidate();
    });
  }

  build() {
    final classes = ['collapsable'];
    if (!collapsed) {
      classes.add('collapsable-open');
    } else {
      classes.add('collapsable-close');
    }
    return new VRootElement(_collapsableChildren, classes: classes);
  }
}

class BasicComponent extends VComponent<ParagraphElement> {
  int _elapsed;
  int get elapsed => _elapsed;

  String get elapsedSeconds => '${(_elapsed / 1000).toStringAsFixed(1)}';

  BasicComponent(Context context, this._elapsed)
      : super(new ParagraphElement(), context);

  void attached() {
    super.attached();
    final start = new DateTime.now().millisecondsSinceEpoch;
    new Timer.periodic(new Duration(milliseconds: 50), (t) {
      _elapsed = new DateTime.now().millisecondsSinceEpoch - start;
      invalidate();
    });
  }

  build() {
    return new VRootElement([vdom.t('Liquid has been successfully '
        'running for $elapsedSeconds seconds.')]);
  }

  void updateProperties(int newElapsed) {
    if (elapsed != newElapsed) {
      _elapsed = newElapsed;
      update();
    }
  }

  static VDomComponent virtual(Object key, int elapsed) {
    return new VDomComponent(key, (component, context) {
      if (component == null) {
        return new BasicComponent(context, elapsed);
      }
      component.updateProperties(elapsed);
    });
  }
}

main() {
  final collapsable = new Collapsable(null, [BasicComponent.virtual(0, 0)]);
  injectComponent(collapsable, document.body);
}
