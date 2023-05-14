from dotenv import load_dotenv
from flask import Flask

load_dotenv()

app = Flask(__name__)

@app.route('/')
def main():
    with open('index.html', 'r') as f:
        return f.read()