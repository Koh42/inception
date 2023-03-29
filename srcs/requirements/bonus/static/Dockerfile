FROM 	alpine:3.16
RUN		apk add --no-cache nodejs npm
WORKDIR	/app
COPY	app .
RUN		npm install express
USER	nobody
CMD		node app.js 8000
