// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.html_view;

import 'dart:async' show Stream, StreamController;
import 'dart:html';

import 'generated/benchmark.pb.dart' as pb;
import 'dashboard_model.dart';
import 'report.dart' show encodeReport, medianSample, maxSample;

/// A dashboard allowing the user to run a benchmark suite and compare the
/// results to any saved report.
class DashboardView {
  static final _template = new DivElement()..innerHtml = '''
<div>
  <button class="dv-run"></button>
  <span class="dv-status"></span>
</div>
<pre class="dv-env"></pre>
Choose baseline: <select class="dv-menu"></select>
<table class="dv-table">
<tr>
  <th>Benchmark</th>
  <th>Params</th>
  <th colspan=4>1000 * int32 reads / second</th>
</tr>
<tr>
  <th></th>
  <th></th>
  <th>Baseline</th>
  <th>Median</th>
  <th>Max</th>
  <th>Count</th>
<tr>
</table>
<div class="dv-json"></div>
''';

  final DivElement elt;

  final _Button _runButton;
  final _Label _status;
  final PreElement _envElt;
  final _Menu _menu;
  final TableElement _responseTable;
  final _JsonView _jsonView;

  String _renderedPlatform;
  final rows = <_ResponseView>[];

  DashboardView._raw(this.elt, this._runButton, this._status, this._envElt,
    this._menu, this._responseTable, this._jsonView);

  factory DashboardView() {
    var elt = _template.clone(true);
    find(String q) => elt.querySelector(q);
    button(q) => new _Button(find(q));
    label(q) => new _Label(find(q));
    menu(q) => new _Menu(find(q));
    json(q) => new _JsonView(find(q));
    return new DashboardView._raw(elt,
      button('.dv-run'), label('.dv-status'), find('.dv-env'),
      menu('.dv-menu'), find('.dv-table'), json('.dv-json'));
  }

  Stream get onRunButtonClick => _runButton.onClick;
  Stream<String> get onMenuChange => _menu.onChange;

  void render(DashboardModel model) {
    _runButton.render("Run", model.canRun);
    if (!model.latest.hasStatus() || model.latest.status == pb.Status.DONE) {
      _status.render("");
    } else {
      _status.render(model.latest.status.name);
    }

    _renderEnv(model.latest);
    _menu.render(model.savedReports.keys.toList(), model.baselineName);
    _renderResponses(model.getBaselineSamples(), model.latest);
    _jsonView.render(model.latest);
  }

  void _renderEnv(pb.Report r) {
    String newPlatform = r.env.platform.toString();
    if (newPlatform == _renderedPlatform) return;
    _envElt.text = newPlatform;
    _renderedPlatform = newPlatform;
  }

  /// Renders a table with one row for each benchmark.
  void _renderResponses(BaselineSamples baseline, pb.Report r) {
    var it = r.responses.iterator;

    // Update existing rows
    for (var row in rows) {
      var hasNext = it.moveNext();
      assert(hasNext); // assume that the table only grows
      var left = baseline.getSample(it.current.request);
      row.render(left, it.current);
    }

    // Add any new rows
    while (it.moveNext()) {
      var left = baseline.getSample(it.current.request);
      var row = new _ResponseView()..render(left, it.current);
      _responseTable.append(row.elt);
      rows.add(row);
    }
  }
}

/// A single row in the benchmark table.
///
/// Displays how many samples were collected and the median and max samples.
/// Also displays a baseline sample for comparison.
class _ResponseView {
  final elt = new TableRowElement();
  final _name = new _Label(new TableCellElement());
  final _params = new _Label(new TableCellElement());
  final _baseline = new _SampleView();
  final _median = new _SampleView();
  final _max = new _SampleView();
  final _count = new _Label(new TableCellElement()..style.textAlign = "right");

  _ResponseView() {
    elt.children.addAll([
      _name.elt,
      _params.elt,
      _baseline.elt,
      _median.elt,
      _max.elt,
      _count.elt
    ]);
  }

  void render(pb.Sample baseline, pb.Response response) {
    _name.render(response.request.id.name);
    _params.render(response.request.params.toString());
    _baseline.render(baseline);
    _median.render(medianSample(response));
    _max.render(maxSample(response));
    _count.render("${response.samples.length}");
  }
}

/// A table cell holding one sample.
class _SampleView {
  final elt = new TableCellElement()..style.textAlign = "right";
  pb.Sample _rendered;

  void render(pb.Sample s) {
    if (_rendered == s) return;
    elt.text = _renderInt32Reads(s);
    _rendered = s;
  }

  static String _renderInt32Reads(pb.Sample s) {
    if (s == null) return "*";
    double kIntsPerSecond = s.counts.int32Reads * 1000 / s.duration;
    return kIntsPerSecond.toStringAsFixed(1);
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
      new HeadingElement.h2()..text = "Report data as JSON:",
      new PreElement()..text = json
    ]);
    _rendered = json;
  }
}

/// A menu of selectable text items.
class _Menu {
  final SelectElement elt;
  final _changes = new StreamController.broadcast();
  final _options = new List<_MenuOption>();

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
      var opt = new _MenuOption();
      opt.render(it.current, it.current == selected);
      elt.append(opt.elt);
      _options.add(opt);
    }
  }
}

class _MenuOption {
  final elt = new OptionElement();
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
  final _clicks = new StreamController.broadcast();
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
