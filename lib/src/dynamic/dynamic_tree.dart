// Copyright (c) 2014, the Liquid project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of liquid.dynamic;

/// Dynamic Tree VDom Node generated by dynamic tree factory.
///
/// Dynamic tree nodes are simple stateless nodes with lazy subtree generation.
/// Subtree is created when `update()` or `render()` method is invoked.
///
/// Right now it doesn't provide any benefits compared to simple functions
/// that create virtual trees, but in the future, when we define rules
/// for `@property`-like annotations, it will work as an optimization technique.
class VDynamicTree extends VStaticTree {
  /// Metadata information about properties. It is used only in mirror-based
  /// implementation.
  HashMap<Symbol, Property> _propertyTypes;

  VDynamicTree(
      this._propertyTypes,
      Function buildFunction,
      Map<Symbol, dynamic> properties,
      Object key,
      List<vdom.VNode> children,
      String id,
      Map<String, String> attributes,
      List<String> classes,
      Map<String, String> styles)
      : super(buildFunction, properties, key, children, id, attributes,
          classes, styles);

  void update(VStaticTree other, vdom.Context context) {
    super.update(other, context);
    other._vTree = other.build();
    assert(invariant(other._vTree != null,
        'build() method should return Virtual DOM Node, but instead returns '
        '`null` value.'));
    _vTree.update(other._vTree, context);
  }
}

/// Factory generated by [dynamicTreeFactory] method.
class _VDynamicTreeFactory extends Function {
  /// build function that generates virtual dom.
  Function _buildFunction;

  ClosureMirror _closureMirror;
  HashMap<Symbol, Property> _propertyTypes;

  _VDynamicTreeFactory(this._buildFunction) {
     _closureMirror = reflect(_buildFunction);
     assert(() {
       for (final param in _closureMirror.function.parameters) {
         if (!param.isNamed) {
           throw new AssertionFailure(
               'Dynamic Tree factories doesn\'t support positional arguments.');
         }
       }
       return true;
     }());
     _propertyTypes = _lookupProperties(_closureMirror.function.parameters);
  }

  /// Creates a new instance of [VDynamicTree] with [args] properties.
  VDynamicTree _create([Map args]) {
    if (args == null) {
      return new VDynamicTree(_propertyTypes, _buildFunction, null, null, null,
          null, null, null, null);
    }
    final HashMap<Symbol, dynamic> properties = new HashMap.from(args);
    final Object key = properties.remove(#key);
    final List<vdom.VNode> children = properties.remove(#children);
    final String id = properties.remove(#id);
    final Map<String, String> attributes = properties.remove(#attributes);
    final List<String> classes = properties.remove(#classes);
    final Map<String, String> styles = properties.remove(#styles);
    assert(() {
      for (final property in properties.keys) {
        if (!_propertyTypes.containsKey(property)) {
          throw new AssertionFailure(
              'Dynamic Tree Node doesn\'t have a property $property.');
        }
      }
      return true;
    }());
    return new VDynamicTree(_propertyTypes, _buildFunction, properties,
        key, children, id, attributes, classes, styles);
  }

  /// It is used to implement variadic arguments.
  VDynamicTree noSuchMethod(Invocation invocation) {
    assert(invariant(invocation.positionalArguments.isEmpty, () =>
        'Dynamic Tree factory invocation shouldn\'t have positional arguments.\n'
        'Positional arguments: ${invocation.positionalArguments}'));
    return _create(invocation.namedArguments);
  }

  /// Factory method invoked without any arguments.
  VDynamicTree call() => _create();
}

/// [dynamicTreeFactory] function generates new factory for dynamic tree vdom
/// nodes.
///
/// Dynamic tree nodes are simple stateless nodes with lazy subtree generation.
/// Subtree is created when `update()` or `render()` method is invoked.
///
/// Right now it doesn't provide any benefits compared to simple functions
/// that create virtual trees, but in the future, when we define rules
/// for `@property`-like annotations, it will work as an optimization technique.
///
/// [dynamicTreeFactory] function should be treated as part of Liquid DSL,
/// and it should be invoked only in top-level declarations:
///
/// ```dart
/// final myNewElement = dynamicTreeFactory(({int counter}) =>
///     div()(counter.toString()));
/// ```
///
/// When the project is compiled with transformer, call to this function will be
/// transformed into an optimized Class with function to instantiate it.
Function dynamicTreeFactory(Function buildFunction) =>
    new _VDynamicTreeFactory(buildFunction);
