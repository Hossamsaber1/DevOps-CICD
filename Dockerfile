FROM python:3.10
WORKDIR /app
COPY . .
RUN pip insatll -r requirements.txt
CMD [ "python", "app.py" ]
