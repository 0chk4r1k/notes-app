FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
COPY package-lock.json ./

RUN npm ci

COPY . .

RUN npx prisma generate

EXPOSE 5000

CMD ["npm", "start"]
