FROM node:16
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y unzip

# Copy application code
COPY resources/codebase_partner/package*.json ./
RUN npm install
COPY resources/codebase_partner/ .

EXPOSE 80
CMD ["npm", "start"]
