# Eric was here
from flask import Flask, url_for, request, jsonify
from bson.json_util import dumps

# Pymongo
import pymongo
from pymongo import MongoClient

MONGO_URL = "mongodb+srv://7DeadlyScrums:EvanChan@studentcluster.rgn2a7g.mongodb.net/?retryWrites=true&w=majority"

# Get database from MongoDB using key
client = MongoClient(MONGO_URL)
db = client.students
students = db.studentCollection

# Ensures all student 'id' properties are unique
students.create_index([('id', pymongo.ASCENDING)], unique=True)

# App stuff idrk
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

# Main stuff
@app.route('/')
def main():
    for resource in STATIC_RESOURCES:
        url_for('static', filename=resource)

    with open('index.html', 'r') as f:
        return f.read()



# Creates student object in database
@app.route('/create', methods=['GET', 'POST'])
def create():
    # Gets request and attempt to insert in database
    json = request.get_json()
    try:  
        result = students.insert_one(json)

    # If exception, print error (only error if try to insert student with existing ID)
    except Exception as e:
        print("EXCEPTION: " + str(e))

    # Return original request body
    finally:
        return request.data



# Retrieves list of student objects in json and returns it for interface view
@app.route('/read')
def read():
    cursor = students.find({}, {'_id': False})
    json_data = dumps(cursor)
    return json_data



# Local function that searches the database using student ID
# Returns student object if exists, otherwise returns nothing
def findStudent(ID):
    student = students.find({'id': ID}, {'_id': False})
    data = list(student)
    student_exists = (len(data) > 0)
    if student_exists:
        return data[0]
    else:
        return None



# Updates student information by ID
@app.route('/update', methods = ['POST'])
def update():
    # Check if student exists
    json = request.get_json()
    ID = json['id']
    student = findStudent(ID)
    if student:
        # Update database
        updates = json['student']
        filtering = {'id': ID}
        newUpdates = {"$set": updates}
        students.update_one(filtering, newUpdates)
    return request.data



# Removes student(s) from the database
@app.route('/delete', methods = ['POST'])
def delete():
    # Get IDs
    IDs = request.get_json()

    # If more than one ID is listed, delete all
    if len(IDs) > 1:
        students.delete_many({})

    # Else, delete individual ID if exists
    else:
        ID = IDs[0]
        student = findStudent(ID)
        if student:
            students.delete_one({'id': ID})
    return request.data

# Silly raf
@app.route('/raf')
def raf():
    return '<img src="static/raf.jpg" />'
