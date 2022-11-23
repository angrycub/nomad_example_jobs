FROM alpine
RUN mkdir /scripts
COPY *.sh /scripts
RUN chmod +x /scripts/*.sh
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["/scripts/cmd.sh","$VAR1","$VAR2"]
