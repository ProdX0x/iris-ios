// Faithful extraction of the physics/validation core of attention-indirecte.html (no canvas, no audio).
// Produces golden traces used by the Swift test-suite to prove the port is numerically equivalent.
function makeNoise1D(seed) {
  let s = seed;
  function rand() { s = (s * 9301 + 49297) % 233280; return s / 233280; }
  const table = Array.from({length: 256}, () => rand() * 2 - 1);
  return function noise(t) {
    const i = Math.floor(t) % 256;
    const f = t - Math.floor(t);
    const a = table[i], b = table[(i + 1) % 256];
    const u = f * f * (3 - 2 * f);
    return a * (1 - u) + b * u;
  };
}
const GAZE_ZONE_MULTIPLIER = 1.6;
function rngFor(seed) { let s = seed; return () => { s = (s * 9301 + 49297) % 233280; return s / 233280; }; }
function randomPoint(rng, margin = 0.2) { return [margin + rng() * (1 - 2 * margin), margin + rng() * (1 - 2 * margin)]; }
function buildLevel(n) {
  const rng = rngFor(2000 + n * 97);
  let count, zone, krep, attr;
  if (n < 3) { count = 1; zone = 220; krep = 0.008; attr = 0.6; }
  else if (n < 8) { count = 2; zone = 190; krep = 0.009; attr = 0.55; }
  else { count = 3; zone = 150; krep = 0.013; attr = 0.5; }
  const targets = [];
  for (let i = 0; i < count; i++) {
    targets.push({ seq: i + 1, start: randomPoint(rng), arrival: randomPoint(rng), zone_attention: zone * GAZE_ZONE_MULTIPLIER, k_repulsion: krep, attraction_passive: attr, amplitude_bruit: 0.15 });
  }
  return { id: `level_${String(n + 1).padStart(2, '0')}`, hold_time_frames: 45, targets, sequential: count > 1 };
}
const RADIUS_TARGET = 24, RADIUS_ARRIVAL = 40, VITESSE_MAX = 2.2, FRICTION = 0.94, MARGE_BORD = 60, PERTE_REBOND = 0.5;

function run(levelIndex, canvas, cursorAt, frames) {
  const level = buildLevel(levelIndex);
  const targets = level.targets.map((cfg, i) => ({
    seq: cfg.seq, x: cfg.start[0] * canvas.width, y: cfg.start[1] * canvas.height, vx: 0, vy: 0,
    arrivalX: cfg.arrival[0] * canvas.width, arrivalY: cfg.arrival[1] * canvas.height,
    zone_attention: cfg.zone_attention, k_repulsion: cfg.k_repulsion, attraction_passive: cfg.attraction_passive,
    amplitude_bruit: cfg.amplitude_bruit, noise: makeNoise1D(1000 + i * 137), holdFrames: 0, holdRequired: level.hold_time_frames, settled: false
  }));
  const levelSequential = level.sequential;
  let t = 0;
  const trace = [];
  const events = [];
  for (let frame = 1; frame <= frames; frame++) {
    const cursor = cursorAt(frame);
    t += 1;
    let allSettled = true;
    let lowestUnsettledSeq = Infinity;
    if (levelSequential) { for (const tg of targets) if (!tg.settled) lowestUnsettledSeq = Math.min(lowestUnsettledSeq, tg.seq); }
    for (const target of targets) {
      const dx = target.x - cursor.x, dy = target.y - cursor.y;
      const d = Math.hypot(dx, dy) || 0.0001;
      if (d < target.zone_attention) {
        const force = target.k_repulsion * (target.zone_attention - d);
        target.vx += (dx / d) * force; target.vy += (dy / d) * force;
      } else {
        const adx = target.arrivalX - target.x, ady = target.arrivalY - target.y;
        const ad = Math.hypot(adx, ady) || 0.0001;
        target.vx += (adx / ad) * target.attraction_passive; target.vy += (ady / ad) * target.attraction_passive;
        target.vx += target.noise(t * 0.02) * target.amplitude_bruit;
        target.vy += target.noise(t * 0.02 + 50) * target.amplitude_bruit;
      }
      const speed = Math.hypot(target.vx, target.vy);
      if (speed > VITESSE_MAX) { target.vx = (target.vx / speed) * VITESSE_MAX; target.vy = (target.vy / speed) * VITESSE_MAX; }
      target.vx *= FRICTION; target.vy *= FRICTION;
      target.x += target.vx; target.y += target.vy;
      if (target.x < MARGE_BORD) { target.x = MARGE_BORD; target.vx *= -PERTE_REBOND; }
      if (target.x > canvas.width - MARGE_BORD) { target.x = canvas.width - MARGE_BORD; target.vx *= -PERTE_REBOND; }
      if (target.y < MARGE_BORD) { target.y = MARGE_BORD; target.vy *= -PERTE_REBOND; }
      if (target.y > canvas.height - MARGE_BORD) { target.y = canvas.height - MARGE_BORD; target.vy *= -PERTE_REBOND; }
      const distToArrival = Math.hypot(target.x - target.arrivalX, target.y - target.arrivalY);
      const isTargetsTurn = !levelSequential || target.settled || target.seq === lowestUnsettledSeq;
      const SETTLE_RADIUS = RADIUS_ARRIVAL - RADIUS_TARGET;
      const WOBBLE_TOLERANCE = SETTLE_RADIUS + 20;
      const wasSettled = target.settled;
      if (target.settled) { if (distToArrival > WOBBLE_TOLERANCE) { target.settled = false; target.holdFrames = 0; } }
      else if (distToArrival < SETTLE_RADIUS && isTargetsTurn) { target.holdFrames += 1; target.settled = target.holdFrames >= target.holdRequired; }
      else { target.holdFrames = 0; }
      if (target.settled && !wasSettled) events.push({frame, type: 'validated', seq: target.seq});
      else if (!target.settled && wasSettled) events.push({frame, type: 'lost', seq: target.seq});
      if (!target.settled) allSettled = false;
    }
    if (levelSequential) {
      let brokenSeq = Infinity;
      for (const tg of targets) if (!tg.settled) { brokenSeq = Math.min(brokenSeq, tg.seq); break; }
      for (const tg of targets) { if (tg.settled && tg.seq > brokenSeq) { tg.settled = false; tg.holdFrames = 0; events.push({frame, type: 'cascade', seq: tg.seq}); allSettled = false; } }
    }
    trace.push(targets.map(tg => ({x: tg.x, y: tg.y, vx: tg.vx, vy: tg.vy, hold: tg.holdFrames, settled: tg.settled})));
    if (allSettled) { events.push({frame, type: 'levelCompleted'}); break; }
  }
  return { levelIndex, canvas, frames: trace.length, trace, events };
}
const canvas = { width: 390, height: 844 };
const scenarioA = run(0, canvas, f => (f <= 150) ? {x: 230, y: 560} : {x: 60, y: 60}, 600);
const scenarioB = run(8, canvas, f => ({x: 330, y: 784}), 1200);
const fs = require('fs');
fs.writeFileSync('golden_level1_scripted.json', JSON.stringify(scenarioA));
fs.writeFileSync('golden_level9_far.json', JSON.stringify(scenarioB));
console.log('A frames', scenarioA.frames, 'events', JSON.stringify(scenarioA.events));
console.log('A frame1', JSON.stringify(scenarioA.trace[0]));
console.log('A frame120', JSON.stringify(scenarioA.trace[119]));
console.log('A last', JSON.stringify(scenarioA.trace[scenarioA.frames-1]));
console.log('B frames', scenarioB.frames, 'events', JSON.stringify(scenarioB.events));
console.log('B last', JSON.stringify(scenarioB.trace[scenarioB.frames-1]));
