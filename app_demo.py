from flask import Flask, render_template, url_for, Response, redirect, g, session, copy_current_request_context, request
import cv2

import urllib
import numpy as np
import mysql.connector
import pyttsx3
import pickle
from datetime import datetime, timedelta
import time
import sys
import os


app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(24)


# 1 Create database connection
myconn = mysql.connector.connect(host="localhost", user="root", passwd="SjxFLYdq", database="face")
# date = datetime.utcnow()
# now = datetime.now()
date = datetime(2022, 11, 15, 11, 45)
now = datetime(2022, 11, 15, 11, 45)
current_time = now.strftime("%H:%M:%S")
cursor = myconn.cursor()


#2 Load recognize and read label from model
recognizer = cv2.face.LBPHFaceRecognizer_create()
recognizer.read("train.yml")

labels = {"person_name": 1}
with open("labels.pickle", "rb") as f:
    labels = pickle.load(f)
    labels = {v: k for k, v in labels.items()}

# create text to speech
engine = pyttsx3.init()
rate = engine.getProperty("rate")
engine.setProperty("rate", 175)

# Define camera and detect face
face_cascade = cv2.CascadeClassifier('haarcascade/haarcascade_frontalface_default.xml')
cap = cv2.VideoCapture(0)

# global variable username userid
user_loginName = None
user_id = -1

@app.route('/')
def index():

    global recognizer, labels, engine, rate, face_cascade, cap
    #2 Load recognize and read label from model
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    recognizer.read("train.yml")

    labels = {"person_name": 1}
    with open("labels.pickle", "rb") as f:
        labels = pickle.load(f)
        labels = {v: k for k, v in labels.items()}

    # create text to speech
    engine = pyttsx3.init()
    rate = engine.getProperty("rate")
    engine.setProperty("rate", 175)

    # Define camera and detect face
    face_cascade = cv2.CascadeClassifier('haarcascade/haarcascade_frontalface_default.xml')
    cap = cv2.VideoCapture(0)

    #reset the login success info in the txt file
    login_file = open("login.txt","w")
    login_file.write("")
    login_file.close()

    return render_template('index.html')

def gen_frames():
    global user_loginName

    loginSuccess = 0
    while loginSuccess == 0:
        success, frame = cap.read()
        if not success:
            break
        else:
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = face_cascade.detectMultiScale(gray, scaleFactor=1.5, minNeighbors=5)

            for (x, y, w, h) in faces:
                print(x, w, y, h)
                roi_gray = gray[y:y + h, x:x + w]
                roi_color = frame[y:y + h, x:x + w]
                # predict the id and confidence for faces
                id_, conf = recognizer.predict(roi_gray)

                # If the face is recognized
                if conf >= 60:
                    login_file = open("login.txt","w")
                    login_file.write("Login Success")
                    login_file.close()
                    # print(id_)
                    # print(labels[id_])
                    font = cv2.QT_FONT_NORMAL
                    id = 0
                    id += 1
                    name = labels[id_]
                    current_name = user_loginName
                    color = (255, 0, 0)
                    stroke = 2
                    cv2.putText(frame, name, (x, y), font, 1, color, stroke, cv2.LINE_AA)
                    cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), (2))

                    # Find the student's information in the database.
                    select = "SELECT student_id, name, DAY(login_date), MONTH(login_date), YEAR(login_date) FROM Student WHERE name='%s'" % (user_loginName)
                    name = cursor.execute(select)
                    result = cursor.fetchall()
                    # print(result)
                    data = "error"

                    for x in result:
                        data = x

                    # If the student's information is not found in the database
                    if data == "error":
                        print("The student", current_name, "is NOT FOUND in the database.")

                    # If the student's information is found in the database
                    else:
                        """
                        Implement useful functions here.
                        Check the course and classroom for the student.
                            If the student has class room within one hour, the corresponding course materials
                                will be presented in the GUI.
                            if the student does not have class at the moment, the GUI presents a personal class 
                                timetable for the student.

                        """
                        # Update the data in database
                        update =  "UPDATE Student SET login_date=%s WHERE name=%s"
                        val = (date, current_name)
                        cursor.execute(update, val)
                        update = "UPDATE Student SET login_time=%s WHERE name=%s"
                        val = (current_time, current_name)
                        cursor.execute(update, val)
                        myconn.commit()
                    
                        hello = ("Hello ", current_name, "You did attendance today")
                        print(hello)
                        engine.say(hello)
                        loginSuccess = 1
                        break
                        # engine.runAndWait()


                # If the face is unrecognized
                else: 
                    color = (255, 0, 0)
                    stroke = 2
                    font = cv2.QT_FONT_NORMAL
                    cv2.putText(frame, "UNKNOWN", (x, y), font, 1, color, stroke, cv2.LINE_AA)
                    cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), (2))
                    hello = ("Your face is not recognized")
                    print(hello)
                    engine.say(hello)
                    # loginSuccess = 0
                    break
                    # engine.runAndWait()

            
            ret, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
        
    # change auth to true

#route call when login button is clicked in login page, with username submitted
@app.route('/faceR', methods = ['POST','GET'])
def faceR():
    global user_loginName
    global user_id

    if request.method == "POST":
        user_loginName = request.form['name']
        print(user_loginName)

        cursor.execute("SELECT student_id FROM Student WHERE name='%s'" % (user_loginName))
        user_id_tem = cursor.fetchall()

        if len(user_id_tem) != 0:
            user_id = user_id_tem[0][0]
            print(user_id)
        else:
            print("NAME NOT FOUND!!")
            user_id = -1

        return {"url":"/camPage"}
    elif user_id != -1:
        return redirect("/faceReg")
    elif user_id == -1:
        return render_template('userName_Error.html')

@app.route('/faceReg')
def faceReg():
    return render_template('camera.html')

@app.route('/faceLogin')
def faceLogin():
    login_file = open("login.txt","r")
    login_info = login_file.readline()
    login_file.close()
    
    print(login_info)
    if login_info == "Login Success":
        cap.release()
        cv2.destroyAllWindows()
        return redirect("/Welcome")
    else:
        return render_template('faceLogin_Error.html')

@app.route('/Welcome')
def Welcome():
    global user_loginName
    cursor.execute("SELECT name, login_time, login_date FROM Student WHERE name='%s'" % (user_loginName))
    Info = cursor.fetchall()
    return render_template('welcome.html',name=Info[0][0],time=Info[0][1],date=Info[0][2])

#couses home page
@app.route('/courseHome')
def courseHome():
    global user_loginName
    global user_id

    cursor.execute("SELECT course_id FROM Enrol WHERE student_id='%s'" % (user_id))
    student_courses = cursor.fetchall()

    #if student hasnt enroll any courses
    #return page indicates that student do not have any courses

    
    # tdy_weekday_num = datetime.today().weekday()
    tdy_weekday_num = 1

    if tdy_weekday_num == 0:
        tdy_weekday_str = "MON"
    elif tdy_weekday_num == 1:
        tdy_weekday_str = "TUE"
    elif tdy_weekday_num == 2:
        tdy_weekday_str = "WED"
    elif tdy_weekday_num == 3:
        tdy_weekday_str = "THU"
    elif tdy_weekday_num == 4:
        tdy_weekday_str = "FRI"
    elif tdy_weekday_num == 5:
        tdy_weekday_str = "SAT"
    elif tdy_weekday_num == 6:
        tdy_weekday_str = "SUN"

    cursor.execute("SELECT * FROM ClassTime")
    Allcourses = cursor.fetchall()

    #time in seconds(now)
    # t = time.localtime(time.time())
    # timeNow_inSeconds = (t.tm_hour * 60 * 60) + (t.tm_min * 60)
    timeNow_inSeconds = 11 * 60 * 60 + 45 * 60

    next_course = None

    #looping all courses
    for course in Allcourses:
        #looping all courses that the student enroll
        for student_course in student_courses:
            #if the enroll course of student matched the course
            if course[0] == student_course[0]:

                #if the course is in today
                if course[3] == tdy_weekday_str:
                    #if the course is within one hour and it is not negative value
                    if (course[1].total_seconds() - timeNow_inSeconds) / 60 / 60 <= 1 and (course[1].total_seconds() - timeNow_inSeconds) / 60 / 60 >= 0:
                        next_course = course
                        
                        course_id = next_course[0]

                        cursor.execute("SELECT zoom_link, teacher_msg FROM Course WHERE course_id='%s'" % (course_id))
                        course_info = cursor.fetchall()
                        zoom_link = course_info[0][0]
                        teacher_msg = course_info[0][1]

                        cursor.execute("SELECT room_id FROM TakePlace WHERE course_id='%s'" % (course_id))
                        room_info = cursor.fetchall()
                        room_id = room_info[0][0]

                        cursor.execute("SELECT note_link FROM CourseNote WHERE course_id='%s'" % (course_id))
                        note_info = cursor.fetchall()
                        note_link = note_info[0][0]

                        cursor.execute("SELECT address FROM Classroom WHERE room_id='%s'" % (room_id))
                        address_info = cursor.fetchall()
                        address = address_info[0][0]


    if next_course != None:
        return render_template('courseHome.html', next_course=next_course, zoom_link=zoom_link, teacher_msg=teacher_msg, room_id=room_id, note_link=note_link, address=address)
    else:
        print("Allcourses")
        print(Allcourses)

        def get_time(record):
            return record[1].total_seconds()
        sort_Allcourses = sorted(Allcourses, key=get_time, reverse=False)

        print(sort_Allcourses)

        sort_student_Allcourses = []
        #looping all courses
        for course in sort_Allcourses:
            #looping all courses that the student enroll
            for student_course in student_courses:
                if course[0] == student_course[0]:

                    cursor.execute("SELECT room_id FROM TakePlace WHERE course_id='%s'" % (course[0]))
                    room_info_tem = cursor.fetchall()
                    room_id_tem = room_info_tem[0][0]

                    course = course + (room_id_tem,)
                    sort_student_Allcourses.append(course)
        
        print(sort_student_Allcourses)
        return render_template('timeTable.html', sort_student_Allcourses=sort_student_Allcourses)

#function for returning sources(not html)
@app.route('/video_feed')
def video_feed():
    gf = gen_frames() 
    res = Response(gf, mimetype='multipart/x-mixed-replace; boundary=frame')
    print(gf)
    return res



if __name__ == "__main__":
    app.run(debug=True)