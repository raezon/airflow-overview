FROM debian:latest
RUN apt update && apt install htop -y
COPY script.sh .
Run echo "bonjour"
Run chmod +x script.sh
#ENTRYPOINT ["./script.sh"]
#CMD ["#!/bin/bash", "echo", "hello"]
CMD echo "hello" &&  echo "test"