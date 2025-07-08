# Use a base image with Flutter installed
FROM cirrusci/flutter:latest

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web

# Output directory
CMD ["cp", "-r", "build/web", "/vercel/output/"]
