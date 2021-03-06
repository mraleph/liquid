// Copyright (c) 2014, the Liquid project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:liquid/liquid.dart';
import 'package:liquid/vdom.dart' as vdom;

class HelloComponent extends Component<DivElement> {
  @property() String name;

  build() => vdom.root()('Hello $name');
}

main() {
  injectComponent(new HelloComponent()..name = 'World', document.body);
}