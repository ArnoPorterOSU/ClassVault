from dotenv import load_dotenv
from flask import Flask

load_dotenv()

app = Flask(__name__)
app.config.from_envvar('PORT')