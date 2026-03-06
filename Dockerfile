FROM python:3.14

WORKDIR /app

# install all dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# move over the project files
COPY . .

RUN rm -rf /app/resources/persisted/*
RUN rm -rf /app/resources/shared/*
RUN rm -rf /app/b_txt_templates

EXPOSE 7777

# move over template files
# /usr/local/share/jupyter

COPY ./b_txt_templates/nbconvert/templates/ /usr/local/share/jupyter/nbconvert/templates/

COPY ./b_txt_templates/voila/templates/ /usr/local/share/jupyter/voila/templates/

CMD [ "voila", "--VoilaConfiguration.allow_template_override=NO", "--port=7777", "--no-browser", "--Voila.ip=0.0.0.0", "--template=b-txt-app", "/app/index.ipynb" ]