/**
 * Ultra-Smooth Scroll-Driven Frame Animation Engine
 * Total Frames: 192 (24fps 8-second sequence)
 */

(function () {
  'use strict';

  // --- Configuration ---
  const TOTAL_FRAMES = 192;
  const LERP_FACTOR = 0.085; // Inertial smoothing coefficient (0.05 = very smooth/heavy, 0.12 = snappier)
  const FRAME_FILE_PREFIX = 'frames/frame_';
  const FRAME_FILE_SUFFIX = '.png';

  // Pad frame numbers to 4 digits: frame_0001.png
  function getFramePath(index) {
    const padded = String(index).padStart(4, '0');
    return `${FRAME_FILE_PREFIX}${padded}${FRAME_FILE_SUFFIX}`;
  }

  // --- DOM Elements ---
  const canvas = document.getElementById('animation-canvas');
  const ctx = canvas.getContext('2d', { alpha: false }); // false optimizes rendering speed
  const scrollTrack = document.getElementById('scroll-track');
  const scrollIndicator = document.getElementById('scroll-indicator');
  const loader = document.getElementById('loader');
  const loaderPercent = document.getElementById('loader-percent');
  const loaderProgressBar = document.getElementById('loader-progress-bar');
  const loaderFramesCount = document.getElementById('loader-frames-count');
  const hudFrameCounter = document.getElementById('hud-frame-counter');
  const hudProgressFill = document.getElementById('hud-progress-fill');
  const hudProgressPct = document.getElementById('hud-progress-pct');
  const scrubBar = document.getElementById('interactive-scrub-bar');

  // --- State Variables ---
  const images = new Array(TOTAL_FRAMES + 1);
  let loadedCount = 0;
  let targetProgress = 0;
  let currentProgress = 0;
  let renderedFrameIndex = -1;
  let isLoaderDismissed = false;
  let isDraggingScrubber = false;

  // --- Nearest Loaded Frame Fallback ---
  function getBestLoadedImage(requestedIndex) {
    if (images[requestedIndex] && images[requestedIndex].isLoaded) {
      return images[requestedIndex];
    }
    // Search outwards for nearest loaded frame
    for (let offset = 1; offset < TOTAL_FRAMES; offset++) {
      const prev = requestedIndex - offset;
      if (prev >= 1 && images[prev]?.isLoaded) return images[prev];
      const next = requestedIndex + offset;
      if (next <= TOTAL_FRAMES && images[next]?.isLoaded) return images[next];
    }
    return null;
  }

  // --- Canvas Sizing & High-DPI Handling ---
  function resizeCanvas() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2); // Cap at 2 for fluid 60fps performance
    const w = window.innerWidth;
    const h = window.innerHeight;

    if (canvas.width !== Math.round(w * dpr) || canvas.height !== Math.round(h * dpr)) {
      canvas.width = Math.round(w * dpr);
      canvas.height = Math.round(h * dpr);
    }

    // Force redraw of current frame
    if (renderedFrameIndex > 0) {
      drawFrame(renderedFrameIndex, true);
    }
  }

  // --- Frame Rendering with "Cover" Aspect Ratio ---
  function drawFrame(frameIndex, forceRedraw = false) {
    if (!forceRedraw && frameIndex === renderedFrameIndex) return;

    const img = getBestLoadedImage(frameIndex);
    if (!img) return;

    renderedFrameIndex = frameIndex;

    const cw = canvas.width;
    const ch = canvas.height;
    const iw = img.naturalWidth || img.width;
    const ih = img.naturalHeight || img.height;

    if (!iw || !ih) return;

    // Cover calculation: center and scale source frame to fill canvas
    const canvasRatio = cw / ch;
    const imgRatio = iw / ih;

    let sx, sy, sw, sh;

    if (canvasRatio > imgRatio) {
      // Screen is wider than 16:9
      sw = iw;
      sh = iw / canvasRatio;
      sx = 0;
      sy = (ih - sh) / 2;
    } else {
      // Screen is taller than 16:9 (e.g. mobile portrait)
      sh = ih;
      sw = ih * canvasRatio;
      sx = (iw - sw) / 2;
      sy = 0;
    }

    // High performance GPU blit
    ctx.drawImage(img, sx, sy, sw, sh, 0, 0, cw, ch);

    // Update HUD
    updateHUD(frameIndex);
  }

  // --- HUD Updates ---
  function updateHUD(frameIndex) {
    if (hudFrameCounter) {
      hudFrameCounter.textContent = `${String(frameIndex).padStart(3, '0')} / ${TOTAL_FRAMES}`;
    }
    const percent = Math.round(currentProgress * 100);
    if (hudProgressFill) {
      hudProgressFill.style.width = `${percent}%`;
    }
    if (hudProgressPct) {
      hudProgressPct.textContent = `${percent}%`;
    }
  }

  // --- Navigation Link Active Tracking ---
  const navLinks = document.querySelectorAll('.nav-link');
  const navSections = document.querySelectorAll('section[id], footer[id]');

  function updateActiveNavLink() {
    if (!navLinks.length || !navSections.length) return;
    const scrollPos = (window.scrollY || document.documentElement.scrollTop) + 220;

    let activeId = '';
    navSections.forEach((sec) => {
      const top = sec.offsetTop;
      const height = sec.offsetHeight;
      if (scrollPos >= top && scrollPos < top + height) {
        activeId = sec.getAttribute('id');
      }
    });

    if (activeId) {
      navLinks.forEach((link) => {
        const href = link.getAttribute('href');
        if (href === `#${activeId}`) {
          link.classList.add('active');
        } else {
          link.classList.remove('active');
        }
      });
    }
  }

  // --- Preloading Strategy ---
  function dismissLoader() {
    if (isLoaderDismissed) return;
    isLoaderDismissed = true;
    loader.classList.add('hidden');
    setTimeout(() => {
      loader.style.display = 'none';
    }, 700);
  }

  function onImageLoaded(index) {
    loadedCount++;
    const pct = Math.min(Math.round((loadedCount / TOTAL_FRAMES) * 100), 100);

    loaderPercent.textContent = `${pct}%`;
    loaderProgressBar.style.width = `${pct}%`;
    loaderFramesCount.textContent = `${loadedCount} / ${TOTAL_FRAMES} frames`;

    // Render frame 1 immediately when ready
    if (index === 1 && renderedFrameIndex === -1) {
      drawFrame(1, true);
    }

    // Dismiss loader once key frames are loaded (~24 frames)
    if (loadedCount >= 24 && !isLoaderDismissed) {
      dismissLoader();
    }
  }

  function preloadImages() {
    // Safety fallback: ensure page is interactive after 2.5 seconds regardless of network speed
    setTimeout(() => {
      if (!isLoaderDismissed) {
        dismissLoader();
      }
    }, 2500);

    // 1. Prioritize frame 1
    const firstImg = new Image();
    firstImg.src = getFramePath(1);
    firstImg.onload = () => {
      firstImg.isLoaded = true;
      images[1] = firstImg;
      onImageLoaded(1);
      drawFrame(1, true);
    };
    firstImg.onerror = () => {
      console.warn(`Failed loading frame 1`);
      loadedCount++;
    };

    // 2. Load the rest in prioritized order:
    // First keyframes (every 6th frame) for rapid full-timeline coverage,
    // then fill in the intermediate frames.
    const keyframes = [];
    const restFrames = [];

    for (let i = 2; i <= TOTAL_FRAMES; i++) {
      if (i % 6 === 0) {
        keyframes.push(i);
      } else {
        restFrames.push(i);
      }
    }

    const loadOrder = [...keyframes, ...restFrames];

    // Throttle loading in parallel batches of 4 for optimal socket streaming
    let currentIndex = 0;
    const CONCURRENCY = 4;

    function loadNextBatch() {
      while (currentIndex < loadOrder.length && CONCURRENCY > 0) {
        const frameIdx = loadOrder[currentIndex++];
        const img = new Image();
        img.src = getFramePath(frameIdx);

        img.onload = () => {
          img.isLoaded = true;
          images[frameIdx] = img;
          onImageLoaded(frameIdx);
          loadNextBatch();
        };

        img.onerror = () => {
          loadedCount++;
          loadNextBatch();
        };
      }
    }

    // Kick off parallel workers
    for (let c = 0; c < CONCURRENCY; c++) {
      loadNextBatch();
    }
  }

  // --- Scroll Tracking ---
  function onScroll() {
    const docElem = document.documentElement;
    const docBody = document.body;
    const scrollHeight = Math.max(docElem.scrollHeight, docBody.scrollHeight, scrollTrack ? scrollTrack.scrollHeight : 0);
    const maxScroll = scrollHeight - window.innerHeight;
    if (maxScroll <= 0) return;

    const scrollTop = window.scrollY || docElem.scrollTop || docBody.scrollTop || 0;
    targetProgress = Math.min(Math.max(scrollTop / maxScroll, 0), 1);

    // Fade scroll invitation indicator once scrolled
    if (scrollIndicator) {
      if (scrollTop > 24) {
        scrollIndicator.classList.add('faded');
      } else {
        scrollIndicator.classList.remove('faded');
      }
    }

    updateActiveNavLink();
  }

  // --- Inertial Render Loop (Lerp) ---
  function renderLoop() {
    // Linear Interpolation: current += (target - current) * factor
    const delta = targetProgress - currentProgress;

    if (Math.abs(delta) > 0.0001) {
      currentProgress += delta * LERP_FACTOR;
    } else {
      currentProgress = targetProgress;
    }

    // Convert progress (0.0 to 1.0) to frame index (1 to TOTAL_FRAMES)
    const exactFrame = 1 + currentProgress * (TOTAL_FRAMES - 1);
    const targetFrameIndex = Math.min(Math.max(1, Math.round(exactFrame)), TOTAL_FRAMES);

    drawFrame(targetFrameIndex);

    requestAnimationFrame(renderLoop);
  }

  // --- Interactive Scrubber Drag / Click ---
  function scrubToEvent(e) {
    if (!scrubBar) return;
    const rect = scrubBar.getBoundingClientRect();
    const clickX = e.clientX - rect.left;
    const progress = Math.min(Math.max(clickX / rect.width, 0), 1);
    const maxScroll = scrollTrack.scrollHeight - window.innerHeight;

    window.scrollTo({
      top: progress * maxScroll,
      behavior: 'auto'
    });
  }

  function setupInteractiveScrubber() {
    if (!scrubBar) return;

    scrubBar.addEventListener('mousedown', (e) => {
      isDraggingScrubber = true;
      scrubToEvent(e);
    });

    window.addEventListener('mousemove', (e) => {
      if (isDraggingScrubber) {
        scrubToEvent(e);
      }
    });

    window.addEventListener('mouseup', () => {
      isDraggingScrubber = false;
    });

    // Touch support for scrubber
    scrubBar.addEventListener('touchstart', (e) => {
      isDraggingScrubber = true;
      if (e.touches.length > 0) scrubToEvent(e.touches[0]);
    }, { passive: true });

    window.addEventListener('touchmove', (e) => {
      if (isDraggingScrubber && e.touches.length > 0) {
        scrubToEvent(e.touches[0]);
      }
    }, { passive: true });

    window.addEventListener('touchend', () => {
      isDraggingScrubber = false;
    });
  }

  // --- Keyboard Navigation (Arrow Keys / PageUp / PageDown) ---
  window.addEventListener('keydown', (e) => {
    const docElem = document.documentElement;
    const scrollHeight = Math.max(docElem.scrollHeight, document.body.scrollHeight);
    const maxScroll = scrollHeight - window.innerHeight;
    if (maxScroll <= 0) return;
    const step = maxScroll / (TOTAL_FRAMES - 1);

    if (e.key === 'ArrowDown' || e.key === 'ArrowRight') {
      window.scrollBy({ top: step * 3, behavior: 'smooth' });
    } else if (e.key === 'ArrowUp' || e.key === 'ArrowLeft') {
      window.scrollBy({ top: -step * 3, behavior: 'smooth' });
    }
  });

  // --- Initialization ---
  function init() {
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas, { passive: true });
    window.addEventListener('scroll', onScroll, { passive: true });

    setupInteractiveScrubber();
    preloadImages();
    onScroll();
    requestAnimationFrame(renderLoop);
  }

  // Run on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
