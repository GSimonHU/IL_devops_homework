FROM python:3.7-slim-buster
RUN apt update && apt upgrade
RUN apt install -y curl
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN apt install unzip
RUN unzip awscliv2.zip
RUN ./aws/install
COPY . /app
RUN pip install -r /app/requirements.txt
CMD ["python", "/app/app.py"]