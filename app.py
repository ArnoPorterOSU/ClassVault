from flask import Flask, url_for, request, jsonify

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
    return jsonify([
        { "name": (
            { "first": "Evan"
            , "last": "Hock"
            })
        , "id": 1337
        , "email": "hocke@oregonstate.edu"
        , "gpa": 3.92
        , "address": (
            { "city": "Corvallis"
            , "state": "Oregon"
            , "zipCode": 97330
            , "street": "804 NE 2nd St"
            })
        },
        { "name": (
            { "first": "Leeroy"
            , "last": "Jenkins"
            })
        , "id": 5762034481
        , "gpa": 3.4
        , "email": "leeroyjenkins@gmail.com"
        , "address": (
            { "city": "Portland"
            , "state": "Oregon"
            , "zipCode": 96203
            , "street": "2901 SE Division St"
            })
        },
        { "name": (
            { "first": "Bob"
            , "last": "Smith"
            })
        , "email": "bob.smith@gmail.com"
        , "id": 439204234
        , "gpa": 0.5
        , "address": (
            { "street": "905 Circle Blvd"
            , "state": "Oregon"
            , "city": "Corvallis"
            , "zipCode": 97330
            })
        }
    ])


@app.route('/raf')
def raf():
    return '<img src="static/raf.jpg" />'
