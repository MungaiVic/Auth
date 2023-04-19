# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.10-slim

EXPOSE 8000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY authsvc/requirements.txt .
RUN apt-get update && \
    apt-get install -y libpq-dev gcc postgresql-client && \
    python -m pip install --upgrade pip && \
    python -m pip install --no-cache-dir psycopg2-binary && \
    python -m pip install --no-cache-dir gunicorn && \
    python -m pip install --no-cache-dir -r requirements.txt

WORKDIR /app
COPY authsvc /app/authsvc

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# Set the working directory to the authsvc directory
WORKDIR /app/authsvc

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "authsvc.wsgi"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
