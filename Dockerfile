FROM ubuntu
ENTRYPOINT ["top", "-b"]
CMD ["-c"]

#--------------------------------------

FROM nodejs:16.13
COPY build .
ENTRYPOINT [ "/usr/bin/node" ]
CMD [ "run", "index.js" ]

#--------------------------------------
