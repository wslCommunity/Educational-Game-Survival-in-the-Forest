import { chromium } from 'playwright';
import path from 'path';
import { fileURLToPath } from 'url';
import http from 'http';
import fs from 'fs';
import { spawn } from 'child_process';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = __dirname;
const DURATION_MS = 19500;

const mime = {
  '.html': 'text/html; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.css': 'text/css',
  '.js': 'application/javascript',
};

const server = http.createServer((req, res) => {
  const urlPath = decodeURIComponent((req.url || '/').split('?')[0]);
  const rel = urlPath === '/' ? '/ad.html' : urlPath;
  const filePath = path.join(root, rel);
  if (!filePath.startsWith(root)) {
    res.writeHead(403); res.end(); return;
  }
  fs.readFile(filePath, (err, data) => {
    if (err) { res.writeHead(404); res.end('not found'); return; }
    res.writeHead(200, { 'Content-Type': mime[path.extname(filePath)] || 'application/octet-stream' });
    res.end(data);
  });
});

await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
const { port } = server.address();
const url = `http://127.0.0.1:${port}/ad.html`;
console.log('serving', url);

const outDir = path.join(root, 'output');
fs.mkdirSync(outDir, { recursive: true });

const browser = await chromium.launch({
  headless: true,
  args: ['--autoplay-policy=no-user-gesture-required'],
});

const context = await browser.newContext({
  viewport: { width: 1080, height: 1920 },
  deviceScaleFactor: 1,
  recordVideo: {
    dir: outDir,
    size: { width: 1080, height: 1920 },
  },
});

const page = await context.newPage();
await page.goto(url, { waitUntil: 'networkidle' });
await page.evaluate(async () => {
  if (document.fonts?.ready) await document.fonts.ready;
});
// Restart animations cleanly
await page.evaluate(() => {
  document.getElementById('stage')?.getAnimations?.({ subtree: true }).forEach((a) => {
    a.cancel();
    a.play();
  });
});

await page.waitForTimeout(DURATION_MS);
await context.close();
await browser.close();
server.close();

const webm = fs.readdirSync(outDir).find((f) => f.endsWith('.webm'));
if (!webm) throw new Error('No webm recorded');
const src = path.join(outDir, webm);
const silentMp4 = path.join(outDir, 'ad_silent.mp4');

await new Promise((resolve, reject) => {
  const ff = spawn('ffmpeg', [
    '-y', '-i', src,
    '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
    '-r', '30', '-movflags', '+faststart',
    silentMp4,
  ], { stdio: 'inherit' });
  ff.on('exit', (code) => code === 0 ? resolve() : reject(new Error('ffmpeg fail ' + code)));
});

console.log('recorded', silentMp4);
