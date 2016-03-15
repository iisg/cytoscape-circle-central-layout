# Cytoscape Circle Central Layout

## Description
Layout for Cytoscape.js nodes putting nodes around one central

![layout-screen](https://raw.githubusercontent.com/iisg/cytoscape-circle-central-layout/master/images/circle-central-layout.png)

## Dependencies
 * Cytoscape.js >= 2.2
 
## Installation
Require package using bower:

```
bower install iisg/cytoscape-circle-central-layout --save
```

## Usage
Call the layout with
```
cy.layout(
    name: 'circleCentral',
    centralNode: central,
    parentNode: central.data('parentNode'),
    shiftCentral: !central.data('dragged')
)
```
where:
centralNode - is a central node which is put in the centre of a circle
parentNode - is a parent of central node, necessary if you want to push away circle node from its parent 
shiftCentral - whether to push away central from its parent (so that circles are not overlapping each other)
