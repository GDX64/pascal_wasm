main();

async function initWasmModule(canvasMod) {
  const response = await fetch("./app.wasm");
  const bytes = await response.arrayBuffer();
  const wasmModule = await WebAssembly.compile(bytes);
  const result = await WebAssembly.instantiate(wasmModule, {
    env: {
      _haltproc: () => {},
    },
    canvas: canvasMod,
  });
  return result.exports;
}

async function main() {
  const canvas = document.createElement("canvas");
  document.body.appendChild(canvas);
  canvas.width = 800;
  canvas.height = 600;
  const ctx = canvas.getContext("2d");

  // Define the canvas module for wasm to use
  const canvasMod = {
    rect: (x, y, w, h) => ctx.rect(x, y, w, h),
    fill: (color) => {
      ctx.fillStyle = hexToRGB(color);
      ctx.fill();
    },
    stroke: (color) => {
      ctx.fillStyle = hexToRGB(color);
      ctx.stroke();
    },
    beginPath: () => ctx.beginPath(),
    clearCanvas: () => ctx.clearRect(0, 0, canvas.width, canvas.height),
  };

  const exports = await initWasmModule(canvasMod);
  addCandles();

  let lastClose = 150;
  while (true) {
    await new Promise((resolve) => setTimeout(resolve, 100));

    const randomVal = Math.round(Math.random() * 2 - 1);
    lastClose += randomVal;
    lastClose = Math.max(140, lastClose);
    lastClose = Math.min(160, lastClose);
    exports.addCandle(180, 40, 100, lastClose, 2);
    exports.draw();
  }

  function addCandles() {
    exports.addCandle(100, 0, 20, 80, 0);
    exports.addCandle(120, 40, 80, 100, 1);
    exports.addCandle(180, 40, 100, 150, 2);
    exports.draw();
  }
}

function rafl() {
  return new Promise((resolve) => requestAnimationFrame(resolve));
}

function hexToRGB(hex) {
  const r = ((hex >> 8) & 0xf).toString(16);
  const g = ((hex >> 4) & 0xf).toString(16);
  const b = (hex & 0xf).toString(16);
  return `#${r}${r}${g}${g}${b}${b}`;
}
