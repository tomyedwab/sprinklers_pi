#!/bin/bash

# Start the proxy server in the background
dart serve.config.dart &
PROXY_PID=$!

# Start Flutter web server
flutter run -d chrome --web-port 3000 --web-hostname localhost

# When Flutter server stops, kill the proxy server
kill $PROXY_PID 