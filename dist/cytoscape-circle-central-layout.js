(function($$) {
  var CircleCentralLayout;
  CircleCentralLayout = (function() {
    CircleCentralLayout.prototype.defaults = {
      centralNode: void 0,
      parentNode: void 0,
      shiftCentral: false,
      fit: true,
      padding: 30,
      boundingBox: void 0,
      avoidOverlap: true,
      startAngle: 3 / 2 * Math.PI,
      counterclockwise: false,
      sort: void 0,
      animate: false,
      animationDuration: 500,
      ready: void 0,
      stop: void 0
    };

    function CircleCentralLayout(options) {
      this.options = $$.util.extend(true, {}, this.defaults, options);
    }

    CircleCentralLayout.prototype.run = function() {
      var bb, center, centralX, centralY, cy, dTheta, dcos, distanceToAdd, dsin, dx, dy, edgeLength, eles, getPosition, h, j, len, minDistance, node, nodes, options, parentX, parentY, r, rMin, theta, w;
      options = this.options;
      cy = options.cy;
      eles = options.eles;
      nodes = eles.nodes().not(':parent').filter(':unlocked');
      if (options.sort) {
        nodes = nodes.sort(options.sort);
      }
      if (!nodes.length) {
        return this;
      }
      bb = $$.util.makeBoundingBox(options.boundingBox ? options.boundingBox : {
        x1: 0,
        y1: 0,
        w: cy.width(),
        h: cy.height()
      });
      center = {
        x: bb.x1 + bb.w / 2,
        y: bb.y1 + bb.h / 2
      };
      theta = options.startAngle;
      dTheta = 2 * Math.PI / nodes.length;
      minDistance = 0;
      for (j = 0, len = nodes.length; j < len; j++) {
        node = nodes[j];
        w = node.outerWidth();
        h = node.outerHeight();
        minDistance = Math.max(minDistance, w, h);
      }
      r = nodes.length * minDistance * 0.75 / Math.PI;
      r = Math.max(minDistance * 2, r);
      if (nodes.length > 1 && options.avoidOverlap) {
        minDistance *= 1.75;
        dTheta = 2 * Math.PI / nodes.length;
        dcos = Math.cos(dTheta) - Math.cos(0);
        dsin = Math.sin(dTheta) - Math.sin(0);
        rMin = Math.sqrt(minDistance * minDistance / (dcos * dcos + dsin * dsin));
        r = Math.max(rMin, r);
      }
      if (options.shiftCentral && options.parentNode) {
        centralX = options.centralNode.position('x');
        centralY = options.centralNode.position('y');
        parentX = options.parentNode.position('x');
        parentY = options.parentNode.position('y');
        dx = centralX - parentX;
        dy = centralY - parentY;
        edgeLength = Math.sqrt(dx * dx + dy * dy);
        distanceToAdd = options.parentNode.width() * 1.75;
        distanceToAdd += Math.max(0, r - edgeLength);
        options.centralNode._private.position = {
          x: ((distanceToAdd * dx) / edgeLength) + dx + parentX,
          y: ((distanceToAdd * dy) / edgeLength) + dy + parentY
        };
      }
      center = options.centralNode.position();
      getPosition = function(i, element) {
        var position, rx, ry;
        rx = r * Math.cos(theta);
        ry = r * Math.sin(theta);
        position = {
          x: center.x + rx,
          y: center.y + ry
        };
        theta = options.counterclockwise ? theta - dTheta : theta + dTheta;
        return position;
      };
      nodes.layoutPositions(this, options, getPosition);
      return this;
    };

    return CircleCentralLayout;

  })();
  return $$('layout', 'circleCentral', CircleCentralLayout);
})(cytoscape);
