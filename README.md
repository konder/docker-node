NodeJS run by nodemon, with bower and sass
---

# BUILD your image

```shell
FROM konder/node
MAINTAINER konder "konders@gmail.com"

ADD . /src
RUN cd /src; npm install

EXPOSE 3000

CMD [ "nodemon", "/src/app.js" ]
```
