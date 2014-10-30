import 'dart:html';
import 'package:vdom/vdom.dart' as v;
import 'package:liquid/liquid.dart';
import 'package:liquid/components.dart';

class Item {
  static int __nextId = 0;
  final int id;
  String text;

  Item([this.text = '']) : id = __nextId++;
}

class TodoItem extends VComponent {
  Item item;

  TodoItem(ComponentBase parent, this.item) : super(parent, new LIElement());

  void updateProperties(Item newItem) {
    if (item.text != newItem.text) {
      item = newItem;
      invalidate();
    }
  }

  build() => [new v.Text(0, item.text)];

  /// should be auto-generated by Pub Transformer
  static VDomComponent virtual(Object key, ComponentBase parent, Item item) {
    return new VDomComponent(key, (component) {
      if (component == null) {
        return new TodoItem(parent, item);
      } else {
        component.updateProperties(item);
        return component;
      }
    });
  }
}

class TodoList extends VComponent {
  List<Item> items;

  TodoList(ComponentBase parent, this.items) : super(parent, new UListElement());

  build() => items.map((i) => TodoItem.virtual(i.id, this, i)).toList();

  /// should be auto-generated by Pub Transformer
  void updateProperties(List<String> items) {
    invalidate();
  }

  /// should be auto-generated by Pub Transformer
  static VDomComponent virtual(Object key, ComponentBase parent, List<Item> items) {
    return new VDomComponent(key, (component) {
      if (component == null) {
        return new TodoList(parent, items);
      } else {
        component.updateProperties(items);
        return component;
      }
    });
  }
}

class TodoApp extends VComponent {
  final List<Item> items;
  String inputText = '';

  TodoApp(ComponentBase parent, this.items) : super(parent, new DivElement()) {
    _initEventListeners();
  }

  void _initEventListeners() {
    element.onClick.listen((e) {
      if (e.target.matches('button')) {
        _addItem(inputText);
        inputText = '';
        invalidate();
        e.preventDefault();
        e.stopPropagation();
      }
    });
    element.onInput.listen((e) {
      if (e.target.matches('input')) {
        inputText = e.target.value;
      }
    });
  }

  void _addItem(String text) {
    items.add(new Item(text));
  }

  List<v.Node> build() {
    return [
      new v.Element(0, 'h3', [new v.Text(0, 'TODO')]),
      TodoList.virtual(1, this, this.items),
      new v.Element(2, 'form', [
        TextInputComponent.virtual(0, this, inputText),
        new v.Element(1, 'button', [new v.Text(0, 'Add # ${items.length + 1}')])
        ])
      ];
  }
}

main() {
  final updateLoop = new UpdateLoop();
  final root = new RootComponent(updateLoop);
  root.injectComponent(new TodoApp(root, []), querySelector('body'));
}
