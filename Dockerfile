# Use the official Nginx image
FROM nginx:1.21-alpine

# Create directories for app and SSL certificates
RUN mkdir -p /var/www/flutter-app && \
    mkdir -p /etc/nginx/ssl

# Copy Flutter web build files
COPY build/web/ /var/www/flutter-app/

COPY ssl/ /etc/nginx/ssl/

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose both HTTP and HTTPS ports
EXPOSE 4000

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
