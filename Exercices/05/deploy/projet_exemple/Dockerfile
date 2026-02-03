# Use official Node.js image as base
FROM node:20-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application
COPY . .

# Build the NestJS app
RUN npm run build

# Expose the port NestJS will run on
EXPOSE 3000

# Command to run the app
CMD ["node", "dist/main"]
