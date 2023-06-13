from flask import Flask, url_for, request, jsonify
from bson.json_util import dumps

import pprint
import pymongo
from pymongo import MongoClient

MONGO_URL = "mongodb+srv://7DeadlyScrums:EvanChan@studentcluster.rgn2a7g.mongodb.net/?retryWrites=true&w=majority"

client = MongoClient(MONGO_URL)
db = client.students
students = db.studentCollection
students.create_index([('id', pymongo.ASCENDING)], unique=True)

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


@app.route('/create', methods=['GET', 'POST'])
def create():
    json = request.get_json()
    try:  
        result = students.insert_one(json)
    except Exception as e:
        print("EXCEPTION: " + str(e))
    finally:
        return request.data

@app.route('/read')
def read():
    cursor = students.find({}, {'_id': False})
    json_data = dumps(cursor)
    return json_data

def findStudent(ID):
    student = students.find({'id': ID}, {'_id': False})
    data = list(student)
    student_exists = (len(data) > 0)
    if student_exists:
        return data[0]
    else:
        return None

@app.route('/update')
def update():
    ID = 69420
    student = findStudent(ID)
    if student:
        dummy_updates = {
            "name": {
                "first": "Bobbo",
                "last": "Jones",
                "middle": [],
            }
        }

        filtering = {'id': ID}
        newvalues = {"$set": dummy_updates}
        students.update_one(filtering, newvalues)
        return "Student successfully updated!"

    else:
        "Student with ID: " + str(ID) + " does not exist!"


@app.route('/delete', methods = ['POST'])
def delete():
    data = request.data
    split = (str(data)[3:len(data)+1]).split(",")
    if len(split) > 1:
        students.delete_many({})
    else:
        stringID = split[0]
        if stringID != '':
            ID = int(stringID)
            student = findStudent(ID)
            if student:
                students.delete_one({'id': ID})

    return request.data

@app.route('/raf')
def raf():
    return '<img src="static/raf.jpg" />'
