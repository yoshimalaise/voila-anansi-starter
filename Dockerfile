FROM python:3.14

# Perform basic configuration of environment variables 
ENV HF_HOME=/app/resources/persisted/hugging_face_cache
ENV WEBSERVER_PORT=7777

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
COPY ./b_txt_templates/nbconvert/templates/ /usr/local/share/jupyter/nbconvert/templates/
COPY ./b_txt_templates/voila/templates/ /usr/local/share/jupyter/voila/templates/


CMD ["sh", "-c", "voila --VoilaConfiguration.allow_template_override=NOTEBOOK \
    --port=${WEBSERVER_PORT}  \
    --no-browser \
    --Voila.ip=0.0.0.0 \
    --preheat_kernel=True \
    --pool_size=1 \
    --template=b-txt-app \
    /app/index.ipynb" ]