from dotenv import load_dotenv
from flask import Flask, url_for

load_dotenv()

app = Flask(__name__)

STATIC_RESOURCES = (
    'android-chrome-192x192.png',
    'android-chrome-512x512.png',
    'apple-touch-icon.png',
    'elm.js',
    'favicon-16x16.png',
    'favicon32x32.png',
    'favicon.ico',
    'site.webmanifest'
)

@app.route('/')
def main():
    for resource in STATIC_RESOURCES:
        url_for('static', filename=resource)

    with open('index.html', 'r') as f:
        return f.read()