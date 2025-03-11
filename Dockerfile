FROM node:16
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y unzip

# Copy application code
COPY resources/codebase_partner/package*.json ./
RUN npm install
COPY resources/codebase_partner/ .

# Configure environment variables
ENV APP_DB_HOST=db \
    APP_DB_USER=nodeapp \
    APP_DB_PASSWORD=student12 \
    APP_DB_NAME=STUDENTS \
    APP_PORT=80

EXPOSE 80
CMD ["npm", "start"]
