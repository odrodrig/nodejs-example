# FROM docker.io/node
FROM registry.access.redhat.com/ubi8/nodejs-14

# Add application sources
ADD . .

USER root

# Install the dependencies
RUN npm install

# Run script uses standard ways to run the application
CMD npm run -d start