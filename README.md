# Cytoscape Circle Central Layout

## Description
Layout for Cytoscape.js nodes putting nodes around one central

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
