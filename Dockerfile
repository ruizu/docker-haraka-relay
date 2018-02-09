FROM node:9.5

# Environment Variables
ENV HARAKA_VERSION 2.8.16
ENV HARAKA_ROOT /haraka
ENV SMTP_SERVER ""
ENV SMTP_PORT 25
ENV SMTP_USERNAME ""
ENV SMTP_PASSWORD ""
ENV SERVER_HOSTNAME ""

# Install Haraka
RUN yarn global add "Haraka@$HARAKA_VERSION"
RUN mkdir "$HARAKA_ROOT"
RUN haraka -i "$HARAKA_ROOT"
VOLUME /haraka

# Initialize config
COPY entrypoint.sh "$HARAKA_ROOT/entrypoint.sh"
RUN chmod +x "$HARAKA_ROOT/entrypoint.sh"

# Expose port
EXPOSE 25
ENTRYPOINT "$HARAKA_ROOT/entrypoint.sh"
