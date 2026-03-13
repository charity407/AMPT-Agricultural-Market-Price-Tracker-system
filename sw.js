const CACHE_NAME = 'agromarket-cache-v2'; // Bump the version number to force an update

// These paths assume Tomcat serves your app from the /AgroMarket context root
const urlsToCache = [
  './jsp/dashboard.jsp',
  './jsp/navbar.jsp',
  './jsp/error.jsp',
  './css/style.css',
  './js/main.js',
  './login.html',
  './register.html'
];

// Install event: Cache the core files
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(ASSETS_TO_CACHE))
      .then(() => self.skipWaiting())
  );
});

// Activate event: Clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
      );
    })
  );
});

// Fetch event: Serve from cache if offline
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(cachedResponse => {
        // Return cached version if found, otherwise go to the network
        return cachedResponse || fetch(event.request);
      })
  );
});