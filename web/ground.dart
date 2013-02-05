library ground;
import 'dart:html';

class Ground {
  CanvasRenderingContext2D ctx;
  String name;
  List points;
  Ground(this.name, this.points) {
    var h2 = new HeadingElement.h2();
    h2.id = "h2";
    h2.text = name;

    var canvas = new CanvasElement();
    canvas.width = 100;
    canvas.height = 100;

    var div = new DivElement();
    div.id = "div";
    div.children.add(h2);
    div.children.add(canvas);

    var container = new DivElement();
    container.id = "groundContainer";

    container.children.add(div);
    ctx = canvas.getContext('2d');
    ctx.scale(0.5, 0.5);

    document.body.children.add(container);
  }

  clear() {
    ctx.clearRect(0, 0, 200, 200);
  }

  drawPath(path) {
    ctx.strokeStyle = "green";
    ctx.fillStyle = "rgba(236, 138, 4, 0.5)";
    ctx.lineWidth = 3;
    ctx.beginPath();
    var firstPoint = true;
    var l = points.length;
    for (var i = 0; i < l; i++) {
      var idx = path[i];
      var x = points[idx]["x"];
      var y = points[idx]["y"];
      if (firstPoint) {
        ctx.moveTo(x, y);
        firstPoint = false;
      } else {
        ctx.lineTo(x, y);
      }
    }
    ctx.closePath();
    ctx.stroke();
    ctx.fill();
  }

  drawPoints() {
    ctx.fillStyle = "red";
    for (var i = 0; i < points.length; i++) {
      _fillCircle(points[i]["x"], points[i]["y"], 6);
    }
  }

  _fillCircle(aX, aY, aDiameter){
    ctx.beginPath();
    _circle(aX, aY, aDiameter);
    ctx.fill();
  }
  _circle(aX, aY, aDiameter){
    _ellipse(aX, aY, aDiameter, aDiameter);
  }

  // Ellipse methods
  _ellipse(aX, aY, aWidth, aHeight){
    aX -= aWidth / 2;
    aY -= aHeight / 2;
    var hB = (aWidth / 2) * .5522848,
        vB = (aHeight / 2) * .5522848,
        eX = aX + aWidth,
        eY = aY + aHeight,
        mX = aX + aWidth / 2,
        mY = aY + aHeight / 2;
    ctx.moveTo(aX, mY);
    ctx.bezierCurveTo(aX, mY - vB, mX - hB, aY, mX, aY);
    ctx.bezierCurveTo(mX + hB, aY, eX, mY - vB, eX, mY);
    ctx.bezierCurveTo(eX, mY + vB, mX + hB, eY, mX, eY);
    ctx.bezierCurveTo(mX - hB, eY, aX, mY + vB, aX, mY);
    ctx.closePath();
  }
}