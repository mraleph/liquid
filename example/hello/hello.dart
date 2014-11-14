// Copyright (c) 2014, the Liquid project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:vdom/helpers.dart' as vdom;
import 'package:liquid/liquid.dart';

class HelloComponent extends VComponent {
  String name;

  HelloComponent(Context context, this.name) : super('div', context);

  build() {
    return vdom.div(0, [vdom.t('Hello $name')]);
  }
}

main() {
  injectComponent(new HelloComponent(null, 'World'), document.body);
}