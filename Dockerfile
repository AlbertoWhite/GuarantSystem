FROM node:11

WORKDIR /usr/src/app

RUN npm install
COPY . .
EXPOSE 3000
CMD [ "npm", "start" ]
