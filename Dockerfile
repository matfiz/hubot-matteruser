FROM node:9

ARG hubot_owner
ARG hubot_description
ARG hubot_name

RUN useradd -m -s /bin/bash hubot-matteruser

RUN mkdir -p /usr/src/hubot-matteruser
RUN chown hubot-matteruser:hubot-matteruser /usr/src/hubot-matteruser
RUN chown hubot-matteruser:hubot-matteruser /usr/local/lib/node_modules/
RUN chown hubot-matteruser:hubot-matteruser /usr/local/bin/

WORKDIR /usr/src/hubot-matteruser
USER hubot-matteruser
RUN npm install -g yo
RUN npm install -g generator-hubot

RUN echo "No" | yo hubot --adapter matteruser --owner="${hubot_owner}" --name="${hubot_name}" --description="${hubot_desciption}" --defaults \
&& sed -i '/heroku/d' external-scripts.json

RUN npm install hubot-daily-update hubot-standup-alarm hubot-standup --save \
&& sed -i '$s/]/,"hubot-standup", "hubot-daily-update", "hubot-standup-alarm"]/' external-scripts.json 

RUN rm hubot-scripts.json

CMD ["-a", "matteruser"]
ENTRYPOINT ["./bin/hubot"]

EXPOSE 8080
