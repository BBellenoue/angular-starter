#########################
### build environment ###
#########################

# base image
FROM node:10.15.3 as builder

# set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
RUN npm install -g @angular/cli@7.3.8 --unsafe-perm
COPY package.json /usr/src/app/package.json
RUN npm install

# add app
COPY . /usr/src/app

# run test
#RUN npm run test

# generate build
RUN npm run build:prod

##################
### production ###
##################

# base image
FROM nginx:1.15.11-alpine

## Copy our default nginx config
COPY nginx/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# copy artifact build from the 'build environment'
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

# expose port 80
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]
