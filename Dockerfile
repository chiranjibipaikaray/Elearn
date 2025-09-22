# ----------------------------
# 1️⃣ Build Stage
# ----------------------------
FROM node:18-alpine AS build

# Set working directory inside the container
WORKDIR /app

# Copy only package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Build the React app for production
RUN npm run build

# ----------------------------
# 2️⃣ Production Stage
# ----------------------------
FROM nginx:alpine

# Copy the React build output to Nginx's html directory
COPY --from=build /app/build /usr/share/nginx/html

# Optional: replace default nginx config (uncomment if you have your own)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the container
EXPOSE 80

# Start Nginx when container launches
CMD ["nginx", "-g", "daemon off;"]
