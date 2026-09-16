FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY service.py .

# ONE worker on purpose. The service keeps the kitchen state in module globals,
# so a second worker would hold a different picture of stock and the queue and
# roughly half the orders would be judged against the wrong one.
ENV PORT=7860
CMD gunicorn --workers 1 --timeout 120 --bind 0.0.0.0:$PORT service:app
