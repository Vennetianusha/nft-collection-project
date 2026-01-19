# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package files first (for caching)
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install

# Copy rest of the project
COPY . .

# Compile contracts
RUN npx hardhat compile

# Default command: run tests
CMD ["npx", "hardhat", "test"]
