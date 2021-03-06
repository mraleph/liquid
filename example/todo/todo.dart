// Copyright (c) 2014, the Liquid project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:liquid/liquid.dart';
import 'package:liquid/vdom.dart' as vdom;

class Item {
  static int __nextId = 0;
  final int id;
  String text;

  Item([this.text = '']) : id = __nextId++;
}

todoItem({key, item}) => vdom.li(key: key)(item.text);
todoList({items}) {
  return vdom.ul()(items.map((i) => todoItem(key: i.id, item: i)));
}

class TodoApp extends Component<DivElement> {
  @property() List<Item> items;

  String inputText = '';

  void create() {
    super.create();
    _initEventListeners();
  }

  void _initEventListeners() {
    element.onClick.matches('.add-button').listen((e) {
      if (inputText.isNotEmpty) {
        _addItem(inputText);
        inputText = '';
        invalidate();
      }
      e.preventDefault();
      e.stopPropagation();
    });

    element.onChange.matches('input').listen((e) {
      InputElement element = e.matchingTarget;
      inputText = element.value;
      e.stopPropagation();
    });
  }

  void _addItem(String text) {
    items.add(new Item(text));
  }

  build() {
    return vdom.root()([
      vdom.h2()('TODO'),
      todoList(items: items),
      vdom.form()([
        vdom.textInput(value: inputText),
        vdom.button(classes: ['add-button'])('Add item')
      ])
    ]);
  }
}

main() {
  injectComponent(new TodoApp()..items = [], document.body);
}
