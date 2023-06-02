from dotenv import load_dotenv
from flask import Flask, url_for, request

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


@app.route('/create', methods=('GET', 'POST'))
def create():
    # create an entry in the database based on request data
    pass


@app.route('/read')
def read():
    # read an entry from the database based on request data
    pass


@app.route('/raf')
def raf():
    """
    @dataclass
    class Raf:
        TAs : dict[str, TA] = field(default_factory=dict)
    
        @property
        def TAs():
            return...
    """

    return '<img src="static/raf.jpg" />'