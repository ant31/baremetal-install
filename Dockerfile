# Alpine is a lightweight version of Linux.
# apline:latest could also be used
FROM python:3.11
RUN pip install -U 'ansible<3'
RUN apt update  && apt install netcat-openbsd git-crypt -y
RUN mkdir /app
COPY unlock-watch.sh /app
COPY unlock.yaml /app
COPY roles /app/roles
COPY inventory /app/inventory
RUN rm -f /app/inventory/02-k8s-a1.yaml
WORKDIR /app
RUN echo '*.secret.* filter=git-crypt diff=git-crypt\n\
*.secrets.* filter=git-crypt diff=git-crypt\n\
*.key filter=git-crypt diff=git-crypt\n\
**/secrets/** filter=git-crypt diff=git-crypt\n\
**/secret/** filter=git-crypt diff=git-crypt\n\
.gitattributes !filter !diff\n' > /app/.gitattributes
RUN git config --global user.email "2t.antoine@gmail.com" && \
    git config --global user.name "Antoine L" && \
    git init && git add . && git commit -m "Initial commit"
