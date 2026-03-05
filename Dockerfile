FROM python:3.14

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "voila", "/app/index.ipynb", "--VoilaConfiguration.allow_template_override=NO" ]