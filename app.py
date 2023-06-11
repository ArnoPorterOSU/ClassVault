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

# pprint.pprint(students.find_one())


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
    dummy_object = { "name": (
        { "first": "Tiffany"
        , "last": "Li"
        })
        , "id": 69420
        , "email": "litiff@oregonstate.edu"
        , "gpa": 3.99
        , "address": (
            { "city": "Corvallis"
            , "state": "Oregon"
            , "zipCode": 97330
            , "street": "960 SW Washington Ave"
            })
    }

    try:  
        result = students.insert_one(dummy_object)
    except:
        return "Student with ID " + str(dummy_object["id"]) + " already exists!"
    else:
        name = dummy_object["name"]
        return "Successfully added " + name["first"] + " " + name["last"] + " into the student database!"



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
                "last": "Jones"
            }
        }

        filtering = {'id': ID}
        newvalues = {"$set": dummy_updates}
        students.update_one(filtering, newvalues)
        return "Student successfully updated!"

    else:
        "Student with ID: " + str(ID) + " does not exist!"


@app.route('/delete')
def delete():
    ID = 69420
    student = findStudent(ID)
    if student:
        students.delete_one({'id': ID})
        name = student["name"]
        return "Successfully removed " + name["first"] + " " + name["last"] + " from the student database!"
    else:
        return "Student with ID: " + str(ID) + " does not exist!"

    # students.delete_one({'id': studentID})
    


@app.route('/raf')
def raf():
    return '<img src="static/raf.jpg" />'
