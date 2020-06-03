FROM node:12.17-alpine3.11

ARG npm-ci-params

WORKDIR /home/pptruser/app
COPY package*.json ./
RUN npm ci $npm-ci-params
COPY . .

# Puppeteer deps
RUN apk --update add --no-cache \
      chromium \
      nss \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      ttf-liberation

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser

EXPOSE 3000
CMD ["npm", "start"]
