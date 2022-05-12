FROM node:lts

WORKDIR /src
COPY ./package*.json ./
RUN npm i
COPY . .
RUN chown -R node:node /src
USER node

EXPOSE 80
CMD npm run start