FROM node:lts-alpine3.14 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG configuration=production
RUN npm run build -- --outputPath=./dist/out --configuration $configuration

FROM nginx as serve
COPY --from=build /app/dist/out/ /usr/share/nginx/html
COPY /nginx-custom.conf /etc/nginx/conf.d/default.conf
#ENTRYPOINT service nginx start && bash
