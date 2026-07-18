FROM node:18-slim

RUN apt-get update && \
    apt-get install -y lua5.4 && \
    ln -s /usr/bin/lua5.4 /usr/bin/lua && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
