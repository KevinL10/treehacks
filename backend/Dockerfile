# Use an official Python runtime as a parent image
FROM python:3.9-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install python-socketio eventlet

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Install required packages
RUN apk update update
RUN apk add dumb-init

# Start simple init system
ENTRYPOINT ["dumb-init", "--"]

# Run app.py when the container launches
CMD ["python", "app.py"]
