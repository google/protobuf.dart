// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.html_view;

import 'dart:async' show Stream, StreamController, EventSink;
import 'dart:html';

import 'generated/benchmark.pb.dart' as pb;
import 'package:api_benchmark/dashboard_model.dart';
import 'package:api_benchmark/report.dart' show encodeReport;

/// A dashboard allowing the user to run a benchmark suite and compare the
/// results to any saved report.
class DashboardView {
  static const noBaseline = "<none>";

  static final _template = DivElement()
    ..innerHtml = '''
<div>
  <button class="dv-run"></button>
  <button class="dv-select-all"></button>
  <button class="dv-select-none"></button>
  <span class="dv-status"></span>
</div>
<pre class="dv-env"></pre>
Choose baseline: <select class="dv-menu"></select>
<table class="dv-table">
<tr>
  <th></th>
  <th>Benchmark</th>
  <th colspan=5>Samples</th>
</tr>
<tr>
  <th colspan=2></th>
  <th>Baseline</th>
  <th>Median</th>
  <th>Max</th>
  <th>Count</th>
  <th>Units</th>
<tr>
</table>
<div class="dv-json"></div>
''';

  final DivElement elt;

  final _Button _runButton;
  final _Button _selectAllButton;
  final _Button _selectNoneButton;
  final _Label _status;
  final PreElement _envElt;
  final _Menu _menu;
  final TableElement _responseTable;
  final _JsonView _jsonView;

  String _renderedPlatform;
  final rowViews = <_ResponseView>[];

  final _selectionChanges =
      StreamController<SelectEvent<pb.Request>>.broadcast();

  DashboardView._raw(
      this.elt,
      this._runButton,
      this._selectAllButton,
      this._selectNoneButton,
      this._status,
      this._envElt,
      this._menu,
      this._responseTable,
      this._jsonView);

  factory DashboardView() {
    Element elt = _template.clone(true);
    find(String q) => elt.querySelector(q);
    _Button button(q) => _Button(find(q));
    label(q) => _Label(find(q));
    menu(q) => _Menu(find(q));
    json(q) => _JsonView(find(q));
    return DashboardView._raw(
        elt,
        button('.dv-run')
          ..elt.style.color = "#FFFFFF"
          ..elt.style.backgroundColor = "rgb(209, 72, 64)",
        button('.dv-select-all'),
        button('.dv-select-none'),
        label('.dv-status'),
        find('.dv-env'),
        menu('.dv-menu'),
        find('.dv-table'),
        json('.dv-json'));
  }

  Stream get onRunButtonClick => _runButton.onClick;
  Stream get onSelectAllClick => _selectAllButton.onClick;
  Stream get onSelectNoneClick => _selectNoneButton.onClick;
  Stream<String> get onMenuChange =>
      _menu.onChange.map((item) => item == noBaseline ? null : item);
  Stream<SelectEvent<pb.Request>> get onSelectionChange =>
      _selectionChanges.stream;

  void render(DashboardModel model) {
    _runButton.render("Run", model.canRun);
    _selectAllButton.render("Select All", true);
    _selectNoneButton.render("Select None", true);
    if (!model.latest.hasStatus() || model.latest.status == pb.Status.DONE) {
      _status.render("");
    } else {
      _status.render(model.latest.status.name);
    }

    _renderEnv(model.latest);

    var items = [noBaseline]..addAll(model.savedReports.keys);
    var selected = model.table.baseline;
    if (selected == null) selected = noBaseline;
    _menu.render(items, model.table.baseline);

    _renderResponses(model.table, model.latest);
    _jsonView.render(model.latest);
  }

  void _renderEnv(pb.Report r) {
    String newPlatform = r.env.platform.toString();
    if (newPlatform == _renderedPlatform) return;
    _envElt.text = newPlatform;
    _renderedPlatform = newPlatform;
  }

  /// Renders a table with one row for each benchmark.
  void _renderResponses(Table table, pb.Report r) {
    var rowIt = table.rows.iterator;

    // Update existing rows (we assume the table never shrinks)
    for (var view in rowViews) {
      var hasNext = rowIt.moveNext();
      assert(hasNext);
      view.render(rowIt.current, r, _selectionChanges);
    }

    // Add any new rows
    while (rowIt.moveNext()) {
      var row = _ResponseView()..render(rowIt.current, r, _selectionChanges);
      _responseTable.append(row.elt);
      rowViews.add(row);
    }
  }
}

/// A single row in the benchmark table.
///
/// Displays how many samples were collected and the median and max samples.
/// Also displays a baseline sample for comparison.
class _ResponseView {
  final elt = TableRowElement();
  final _selected = _Checkbox<pb.Request>();
  final _summary = _Label(TableCellElement());
  final _baseline = _SampleView();
  final _median = _SampleView();
  final _max = _SampleView();
  final _count = _Label(TableCellElement()..style.textAlign = "right");
  final _units = _Label(TableCellElement());

  _ResponseView() {
    elt.children.addAll([
      _selected.elt,
      _summary.elt,
      _baseline.elt,
      _median.elt,
      _max.elt,
      _count.elt,
      _units.elt
    ]);
  }

  void render(
      Row row, pb.Report r, EventSink<SelectEvent<pb.Request>> rowSelected) {
    var b = row.benchmark;
    var response = row.findResponse(r);
    _selected.render(row.selected, item: row.request, sink: rowSelected);
    _summary.render(b.summary);
    _baseline.render(b.measureSample(row.baseline));
    _median.render(b.measureSample(b.medianSample(response)));
    _max.render(b.measureSample(b.maxSample(response)));
    _count.render(response == null ? "0" : "${response.samples.length}");
    _units.render(row.benchmark.measureSampleUnits);
  }
}

/// A table cell holding the measurement for one sample.
class _SampleView {
  final elt = TableCellElement()..style.textAlign = "right";
  double _rendered;

  void render(double value) {
    if (_rendered == value) return;
    elt.text = _render(value);
    _rendered = value;
  }

  static String _render(double value) {
    if (value == 0.0) return "*";
    return value.toStringAsFixed(0);
  }
}

/// Renders the benchmark report as JSON so it can be copied to a file.
class _JsonView {
  final DivElement elt;
  String _rendered;
  _JsonView(this.elt);

  void render(pb.Report r) {
    // Don't show JSON while benchmarks are in progress.
    String json = "";
    if (r.status == pb.Status.DONE) {
      json = encodeReport(r);
    }

    if (json == _rendered) return;

    elt.children.clear();
    if (json == "") return;
    elt.children.addAll([
      HeadingElement.h2()..text = "Report data as JSON:",
      PreElement()..text = json
    ]);
    _rendered = json;
  }
}

/// A menu of selectable text items.
class _Menu {
  final SelectElement elt;
  final _changes = StreamController<String>.broadcast();
  final _options = List<_MenuOption>();

  _Menu(this.elt) {
    elt.onChange.listen((e) => _changes.add(elt.value));
  }

  Stream<String> get onChange => _changes.stream;

  void render(List<String> items, String selected) {
    var it = items.iterator;

    // Update existing items
    for (var opt in _options) {
      var hasNext = it.moveNext();
      assert(hasNext); // assume menu never shrinks
      opt.render(it.current, it.current == selected);
    }

    // Add any new items
    while (it.moveNext()) {
      var opt = _MenuOption();
      opt.render(it.current, it.current == selected);
      elt.append(opt.elt);
      _options.add(opt);
    }
  }
}

class _MenuOption {
  final elt = OptionElement();
  String _renderedItem;
  bool _renderedSelected;

  void render(String item, selected) {
    if (_renderedItem != item) {
      elt.text = item;
      elt.value = item;
      _renderedItem = item;
    }
    if (_renderedSelected != selected) {
      elt.selected = selected;
      _renderedSelected = selected;
    }
  }
}

class _Label {
  final HtmlElement elt;
  String _rendered;
  _Label(this.elt);

  void render(String text) {
    if (_rendered == text) return;
    elt.text = text;
    _rendered = text;
  }
}

class _Button {
  final ButtonElement elt;
  final _clicks = StreamController.broadcast();
  String _renderedLabel;
  bool _renderedEnabled;

  _Button(this.elt) {
    elt.onClick.listen((e) => _clicks.add(true));
  }

  Stream get onClick => _clicks.stream;

  void render(String label, bool enabled) {
    if (label != _renderedLabel) {
      elt.text = label;
      _renderedLabel = label;
    }
    if (_renderedEnabled != enabled) {
      elt.disabled = !enabled;
      _renderedEnabled = enabled;
    }
  }
}

class _Checkbox<T> {
  final elt = CheckboxInputElement();

  bool _renderedChecked;
  EventSink<SelectEvent<T>> _sink;
  T _item;

  _Checkbox() {
    elt.onChange.listen((e) {
      if (_sink != null) {
        _sink.add(SelectEvent<T>(elt.checked, _item));
      }
    });
  }

  void render(bool checked, {EventSink<SelectEvent<T>> sink, T item}) {
    if (_renderedChecked != checked) {
      elt.checked = checked;
      _renderedChecked = checked;
    }
    _item = item;
    _sink = sink;
  }
}
