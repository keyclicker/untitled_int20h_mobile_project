# coding=utf-8

from flask import Flask, request, send_file, flash, redirect, url_for, send_from_directory
from flask_api import status
import os.path
import json

UPLOAD_FOLDER = os.path.abspath(os.curdir) + "/picture/"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg"}

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

@app.route("/login", methods=["POST"])
def login():
    try:
        username, password = request.json["username"], request.json["password"]
    except KeyError:
        return {"message": "Bad request"}, status.HTTP_400_BAD_REQUEST
    with open("auth.json", "rt") as data_file:
        data = json.load(data_file)
    try:
        assert data[username] == password
    except (KeyError, AssertionError):
        return {"message": "Wrong username or password"}, status.HTTP_403_FORBIDDEN
    return {"message": "Successful"}, status.HTTP_200_OK

@app.route("/user/<username>/achievments", methods=["GET", "POST"])
def user_achievments(username):
    with open("data.json", "rt") as data_file:
        data = json.load(data_file)
    if request.method == "GET":
        try:
            return {"message": "Successful", "list": data["users"][username]["achievments"]}, status.HTTP_200_OK
        except KeyError:
            return {"message": "User not found"}, status.HTTP_400_BAD_REQUEST
    elif request.method == "POST":
        try:
            data["users"][username]["achievments"].append(request.json)
        except KeyError:
            return {"message": "Bad request"}, status.HTTP_400_BAD_REQUEST
        with open("data.json", "wt") as data_file:
            json.dump(data, data_file, indent=2)
        return {"message": "Successful"}, status.HTTP_200_OK

@app.route("/user/<username>/activities", methods=["GET", "POST"])
def user_activities(username):
    with open("data.json", "rt") as data_file:
        data = json.load(data_file)
    if request.method == "GET":
        try:
            return {"message": "Successful", "list": data["users"][username]["activities"]}, status.HTTP_200_OK
        except KeyError:
            return {"message": "User not found"}, status.HTTP_400_BAD_REQUEST
    elif request.method == "POST":
        try:
            new_activity = {"competition": request.json["competition"],
                            "date": request.json["date"],
                            "time": request.json["time"],
                            "distance": request.json["distance"]}
            data["users"][username]["activities"].append(new_activity)
        except KeyError:
            return {"message": "Bad request"}, status.HTTP_400_BAD_REQUEST
        with open("data.json", "wt") as data_file:
            json.dump(data, data_file, indent=2)
        return {"message": "Successful"}, status.HTTP_200_OK

@app.route("/user/<username>/following", methods=["GET", "POST"])
def following(username):
    with open("data.json", "rt") as data_file:
        data = json.load(data_file)
    if request.method == "GET":
        try:
            return {"message": "Successful", "list": data["users"][username]["following"]}, status.HTTP_200_OK
        except KeyError:
            return {"message": "User not found"}, status.HTTP_400_BAD_REQUEST
    elif request.method == "POST":
        try:
            data["users"][username]["following"].append(request.json["user"])
            data["users"][request.json["user"]]["followers"].append(username)
        except KeyError:
            return {"message": "Bad request"}, status.HTTP_400_BAD_REQUEST
        with open("data.json", "wt") as data_file:
            json.dump(data, data_file, indent=2)
        return {"message": "Successful"}, status.HTTP_200_OK

@app.route("/user/<username>/followers", methods=["GET", "POST"])
def followers(username):
    with open("data.json", "rt") as data_file:
        data = json.load(data_file)
    if request.method == "GET":
        try:
            return {"message": "Successful", "list": data["users"][username]["followers"]}, status.HTTP_200_OK
        except KeyError:
            return {"message": "User not found"}, status.HTTP_400_BAD_REQUEST
    elif request.method == "POST":
        try:
            data["users"][username]["followers"].append(request.json["user"])
            data["users"][request.json["user"]]["following"].append(username)
        except KeyError:
            return {"message": "Bad request"}, status.HTTP_400_BAD_REQUEST
        with open("data.json", "wt") as data_file:
            json.dump(data, data_file, indent=2)
        return {"message": "Successful"}, status.HTTP_200_OK

@app.route("/user/<username>/information", methods=["GET", "POST"])
def user_information(username):
    with open("data.json", "rt") as data_file:
        data = json.load(data_file)
    if request.method == "GET":
        try:
            return {"message": "Successful",
                    "name": data["users"][username]["name"],
                    "age": data["users"][username]["age"],
                    "picture": data["users"][username]["picture"]}, status.HTTP_200_OK
        except KeyError:
            return {"message": "User not found"}, status.HTTP_400_BAD_REQUEST
    elif request.method == "POST":
        for value in ["name", "age", "picture"]:
            try:
                data["users"][username][value] = request.json[value]
            except KeyError:
                pass
        with open("data.json", "wt") as data_file:
            json.dump(data, data_file, indent=2)
        return {"message": "Successful"}, status.HTTP_200_OK

@app.route("/user/<username>/hubs", methods=["GET", "POST"])
def user_hubs(username):
    with open("data.json", "rt") as data_file:
        data = json.load(data_file)
    if request.method == "GET":
        try:
            return {"message": "Successful", "list": data["users"][username]["hubs"]}, status.HTTP_200_OK
        except KeyError:
            return {"message": "User not found"}, status.HTTP_400_BAD_REQUEST
    elif request.method == "POST":
        try:
            data["users"][username]["hubs"].append(request.json["title"])
        except KeyError:
            return {"message": "Bad request"}, status.HTTP_400_BAD_REQUEST
        try:
            data["hubs"][request.json["title"]]["members"].append(username)
        except KeyError:
            try:
                data["hubs"][request.json["title"]] = {"competition": request.json["competition"],
                                                       "members": [username]}
            except KeyError:
                return {"message": "Bad request"}, status.HTTP_400_BAD_REQUEST
        with open("data.json", "wt") as data_file:
            json.dump(data, data_file, indent=2)
        return {"message": "Successful"}, status.HTTP_200_OK

@app.route("/hubs", methods=["GET"])
def hubs():
    with open("data.json", "rt") as data_file:
        data = json.load(data_file)
    return data["hubs"], status.HTTP_200_OK

@app.route("/picture/<filename>", methods=["GET", "POST"])
def picture(filename):
    if request.method == "GET":
        if os.path.exists("picture/" + filename):
            return send_file("picture/" + filename, attachment_filename=filename), status.HTTP_200_OK
        else:
            return {"message": "Not Found"}, status.HTTP_404_NOT_FOUND
    elif request.method == "POST":
        if "file" not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        filename = file.filename
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return {"message": "successful"}, status.HTTP_200_OK

if __name__ == "__main__":
    app.run(port=4567)