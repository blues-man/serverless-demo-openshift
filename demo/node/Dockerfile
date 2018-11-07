FROM bucharestgold/centos7-s2i-nodejs:10.x
WORKDIR /opt/app-root/src
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080 3000
CMD ["npm", "start"]