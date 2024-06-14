"use strict";

let _rAF, analyser, audioBuffer, canvas, pmModule;
let isStopped = true;

let presets = [
    'martin - castle in the air',
    'martin - cope - laser dome',
    'martin - the forge of isengard',
    //'Martin - underwater cathedral',  // RuntimeError
];

let presetIdx = 0;

function addAudioData() {
    if (!audioBuffer) return;

    analyser.getByteTimeDomainData(audioBuffer);

    pmModule.ccall(
        'add_audio_data',
        null,
        ['array', 'number'],
        [audioBuffer, audioBuffer.length],
    );
}

function createCanvas() {
    if (canvas) return;

    let container = document.getElementById('container');
    let width = container.clientWidth;
    let height = container.clientHeight;

    canvas = document.createElement('canvas');
    canvas.id = "my-canvas";
    canvas.width = width;
    canvas.height = height;

    container.appendChild(canvas);
}

function cyclePreset() {
    if (!pmModule) return;
    pmModule.loadPresetFile(`presets/${presets[presetIdx]}.milk`);
    if (++presetIdx == presets.length) presetIdx = 0;
}

function destruct() {
    if (!pmModule) return;

    isStopped = true;
    pmModule.destruct();

    if (canvas) {
        let container = document.getElementById('container');
        container.removeChild(canvas);
        canvas = null;
    }
}

function init() {
    if (!pmModule) return;
    createCanvas();
    pmModule.init();
    pmModule.setWindowSize(canvas.width, canvas.height);
}

function loadModule() {
    if (pmModule) return;

    createModule({
        noInitialRun: true,
    })
    .then(module => {
        pmModule = module;
        console.log('module loaded');
    });
}

function enableAudio() {
    // already enabled
    if (audioBuffer) return;

    let audioContext = new AudioContext();

    let inputNode = audioContext.createGain();
    let outputNode = audioContext.createGain();

    inputNode.connect(outputNode);
    outputNode.connect(audioContext.destination);

    let audio = new Audio('demo.mp3');
    let sourceNode = audioContext.createMediaElementSource(audio);
    sourceNode.connect(inputNode);

    audio.loop = true;
    audio.play();

    analyser = audioContext.createAnalyser();
    analyser.fftSize = 256;  // pass 256 samples to projectM
    inputNode.connect(analyser);

    audioBuffer = new Uint8Array(analyser.fftSize);
}

function toggleVisualizer() {
    if (!pmModule) return;

    if (isStopped) {
        isStopped = false;
        init();
        visualize();
    }
    else {
        isStopped = true;
        cancelAnimationFrame(_rAF);
    }
}

function visualize() {
    if (isStopped) return;
    _rAF = requestAnimationFrame(() => visualize());
    addAudioData();
    pmModule.renderFrame();
}

document.addEventListener("DOMContentLoaded", loadModule);
