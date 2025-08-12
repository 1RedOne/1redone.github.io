import Konva from 'konva';

const width = window.innerWidth;
const height = window.innerHeight;

const stage = new Konva.Stage({
  container: 'container',
  width: width,
  height: height,
});

const layer = new Konva.Layer();
stage.add(layer);

// function to generate a list of "targets" (circles)
function generateTargets() {
  const number = 10;
  const result = [];
  while (result.length < number) {
    result.push({
      id: 'target-' + result.length,
      x: stage.width() * Math.random(),
      y: stage.height() * Math.random(),
    });
  }
  return result;
}

const targets = generateTargets();

// function to generate arrows between targets
function generateConnectors() {
  const number = 10;
  const result = [];
  while (result.length < number) {
    const from = 'target-' + Math.floor(Math.random() * targets.length);
    const to = 'target-' + Math.floor(Math.random() * targets.length);
    if (from === to) {
      continue;
    }
    result.push({
      id: 'connector-' + result.length,
      from: from,
      to: to,
    });
  }
  return result;
}

function getConnectorPoints(from, to) {
  const dx = to.x - from.x;
  const dy = to.y - from.y;
  let angle = Math.atan2(-dy, dx);

  const radius = 50;

  return [
    from.x + -radius * Math.cos(angle + Math.PI),
    from.y + radius * Math.sin(angle + Math.PI),
    to.x + -radius * Math.cos(angle),
    to.y + radius * Math.sin(angle),
  ];
}

const connectors = generateConnectors();

// update all objects on the canvas from the state of the app
function updateObjects() {
  targets.forEach((target) => {
    const node = layer.findOne('#' + target.id);
    node.x(target.x);
    node.y(target.y);
  });
  connectors.forEach((connect) => {
    const line = layer.findOne('#' + connect.id);
    const fromNode = layer.findOne('#' + connect.from);
    const toNode = layer.findOne('#' + connect.to);

    const points = getConnectorPoints(
      fromNode.position(),
      toNode.position()
    );
    line.points(points);
  });
}

// generate nodes for the app
connectors.forEach((connect) => {
  const line = new Konva.Arrow({
    stroke: 'black',
    id: connect.id,
    fill: 'black',
  });
  layer.add(line);
});

targets.forEach((target) => {
  const node = new Konva.Circle({
    id: target.id,
    fill: Konva.Util.getRandomColor(),
    radius: 20 + Math.random() * 20,
    shadowBlur: 10,
    draggable: true,
  });
  layer.add(node);

  node.on('dragmove', () => {
    // mutate the state
    target.x = node.x();
    target.y = node.y();

    // update nodes from the new state
    updateObjects();
  });
});

updateObjects();
