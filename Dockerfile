#--------
#stage 1

FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

#---------
#stage 2

FROM node:18-slim

WORKDIR /app

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static

ENV NODE_ENV=production
ENV PORT=3000

RUN adduser --disabled-password --gecos "" user

RUN chown -R user:user /app

USER user

EXPOSE 3000

CMD ["node","server.js"]

