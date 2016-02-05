(($$) ->
  class CircleCentralLayout
    defaults:
      centralNode: undefined # central node of the circle
      parentNode: undefined # parent of central node
      shiftCentral: false # whether to push central node away from its parent
      fit: true # whether to fit the viewport to the graph
      padding: 30 # the padding on fit
      boundingBox: undefined # constrain layout bounds; { x1, y1, x2, y2 } or { x1, y1, w, h }
      avoidOverlap: true # prevents node overlap, may overflow boundingBox and radius if not enough space
      startAngle: 3 / 2 * Math.PI # the position of the first node
      counterclockwise: false # whether the layout should go counterclockwise (true) or clockwise (false)
      sort: undefined # a sorting function to order the nodes; e.g. (a, b) -> a.data('weight') - b.data('weight')
      animate: false # whether to transition the node positions
      animationDuration: 500 # duration of animation in ms if enabled
      ready: undefined # callback on layoutready
      stop: undefined # callback on layoutstop

    constructor: (options) ->
      @options = $$.util.extend(true, {}, @defaults, options)

    run: ->
      options = @options
      cy = options.cy
      eles = options.eles
      nodes = eles.nodes().not(':parent').filter(':unlocked')

      if (options.sort)
        nodes = nodes.sort(options.sort)

      if (!nodes.length)
        return @

      bb = $$.util.makeBoundingBox(if options.boundingBox then options.boundingBox else
        x1: 0, y1: 0, w: cy.width(), h: cy.height())

      center =
        x: bb.x1 + bb.w / 2
        y: bb.y1 + bb.h / 2

      theta = options.startAngle
      dTheta = 2 * Math.PI / nodes.length

      minDistance = 0
      for node in nodes
        w = node.outerWidth()
        h = node.outerHeight()
        minDistance = Math.max(minDistance, w, h)

      #calculate radius of the circle
      r = nodes.length * minDistance * 0.75 / Math.PI # adds some spacing
      r = Math.max(minDistance * 2, r)

      if nodes.length > 1 and options.avoidOverlap  # but only if more than one node (can't overlap)
        minDistance *= 1.75                         # just to have some nice spacing
        dTheta = 2 * Math.PI / nodes.length
        dcos = Math.cos(dTheta) - Math.cos(0)
        dsin = Math.sin(dTheta) - Math.sin(0)
        rMin = Math.sqrt(minDistance * minDistance / (dcos * dcos + dsin * dsin)) # s.t. no nodes overlapping
        r = Math.max(rMin, r)

      #change position of central node if needed
      if options.shiftCentral and options.parentNode
        centralX = options.centralNode.position('x')
        centralY = options.centralNode.position('y')
        parentX = options.parentNode.position('x')
        parentY = options.parentNode.position('y')

        dx = centralX - parentX
        dy = centralY - parentY

        edgeLength = Math.sqrt(dx * dx + dy * dy)
        distanceToAdd = options.parentNode.width() * 1.75 # includes some spacing

        distanceToAdd += Math.max(0, r - edgeLength)

        options.centralNode._private.position =
          x: ((distanceToAdd * dx) / edgeLength) + dx + parentX
          y: ((distanceToAdd * dy) / edgeLength) + dy + parentY

      center = options.centralNode.position()

      getPosition = (i, element) ->
        rx = r * Math.cos(theta)
        ry = r * Math.sin(theta)
        position =
          x: center.x + rx
          y: center.y + ry
        theta = if options.counterclockwise then theta - dTheta else theta + dTheta
        position

      nodes.layoutPositions(@, options, getPosition)

      @ #chaining

  $$(
    'layout',
    'circleCentral',
    CircleCentralLayout
  )
)(cytoscape)
