# Use a lightweight Node.js runtime for the final image
FROM node:20-alpine as runner

# Set the working directory in the container to /app
WORKDIR /app

# Copy the rest of the application code to the working directory
COPY . .


# Install a server to serve the application
RUN npm install -g serve

EXPOSE 4000

# Start the server
CMD ["serve"]