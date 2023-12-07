FROM node:16.2.0 as build

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app/package.json
COPY yarn.lock /usr/src/app/yarn.lock

RUN yarn install

COPY . /usr/src/app

RUN npm run build

# Prod runtime
FROM nginx:1.15.6-alpine

COPY --from=build /usr/src/app/build/ /www/data/

WORKDIR /www/data

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]