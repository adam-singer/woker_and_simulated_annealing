library annealing;
import 'dart:math';
import 'dart:async';

Random random = new Random();

class Annealing {
  int card = 0;
  int k = 0;
  List points = [];
  var weight;
  List currentPath = [];
  var currentWeight = 0;
  var minWeight;
  List minPath = [];
  var t;
  int t0;
  double g;
  int stepsPerT = 10;
  int step = 0;
  double stopValue = 0.000000001;
  var _controller = new StreamController();
  Stream onDone;

  Annealing({this.points, this.t0, this.g, this.stepsPerT}) {
    card = points.length;
    for (var i = 0; i < card; i++) {
      currentPath.add(i);
    }

    t = t0;
    onDone = _controller.stream;
  }

  void go() {
    while (true) {
      cycle();
      if (t < stopValue) {
        break;
      }
    }

    _controller.add(minPath);
  }

  bool adoptPath(List p, w) {
    currentPath = p;
    currentWeight = w;
    if (w < minWeight) {
      minWeight = w;
      minPath = new List.from(p);
      return true;
    }

    return false;
  }

  void cycle() {
    step += 1;
    var newMin = false;
    var tmpPath = oneStep();
    var w = computeWeight(tmpPath);
    if (currentWeight == 0) {
      minWeight = w;
      minPath = new List.from(tmpPath);
      newMin = adoptPath(tmpPath, w);
    } else {
      var df = w - currentWeight;
      if (df > 0) {
        var p = random.nextDouble();
        if (p <= exp(-1 * df / t)) {
          newMin = adoptPath(tmpPath, w);
        }
      } else {
        newMin = adoptPath(tmpPath, w);
      }
    }

    if (step == stepsPerT) {
      step = 0;
      t *= g;
    }
  }

  double computeWeight(List path) {
    var weight = 0.0;
    for (var i = 0; i < card; i++) {
      var idx = path[i];
      var prevIdx;
      if (i == 0) {
        prevIdx = path[card - 1];
      } else {
        prevIdx = path[i - 1];
      }

      var x0 = points[prevIdx]["x"];
      var y0 = points[prevIdx]["y"];

      var x1 = points[idx]["x"];
      var y1 = points[idx]["y"];

      weight += sqrt(
          (x1 - x0) * (x1 - x0) +
          (y1 - y0) * (y1 - y0));
    }

    return weight / (200 * card);
  }

  List oneStep() {
    var i = (random.nextDouble() * card).round().toInt();
    var j = (random.nextDouble() * card).round().toInt();

    while (j == i) {
      j = (random.nextDouble() * card).round().toInt();
    }

    var t = i;

    if (i > j) {
      i = j;
      j = t;
    }

    var v1 = currentPath.getRange(0, i);
    var v2 = currentPath.getRange(i, j - i);
    var v3 = currentPath.getRange(j, card - j);

    var v2reversed = new List();
    while (v2.length != 0) {
      v2reversed.add(v2.removeLast());
    }

    v2reversed.addAll(v3);
    v1.addAll(v2reversed);
    return v1;
  }
}