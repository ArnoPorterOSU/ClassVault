from dotenv import load_dotenv
from flask import Flask, url_for

load_dotenv()

app = Flask(__name__)

@app.route('/')
def main():
    url_for('static', filename='elm.js')
    with open('index.html', 'r') as f:
        return f.read()