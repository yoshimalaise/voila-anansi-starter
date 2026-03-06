FROM python:3.14

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN rm -rf /app/resources/persisted/*
RUN rm -rf /app/resources/shared/*

EXPOSE 7777

CMD [ "voila", "--VoilaConfiguration.allow_template_override=NO", "--port=7777", "--no-browser", "--Voila.ip=0.0.0.0", "/app/index.ipynb" ]