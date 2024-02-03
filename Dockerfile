# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
ARG DART_VERSION=stable

FROM dart:$DART_VERSION AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed

RUN dart pub get --offline
RUN dart compile exe lib/main.dart -o lib/main

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/lib/main /app/lib/

# Include files in the /public directory to enable static asset handling
# COPY --from=build /app/public/ /public
# Start server.
CMD ["/app/lib/main"]