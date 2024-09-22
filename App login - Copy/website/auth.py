from flask import Blueprint, render_template, redirect, url_for,request

auth = Blueprint("auth", __name__)

@auth.route("/login")
def login():
    email = request.form.get("email")
    password = request.form.get("password")
    return render_template("login.html")

@auth.route("/sign-up",methods=['GET','POST'])
def sign_up():
    username = request.form.get("username")
    email = request.form.get("email")
    password = request.form.get("password")
    passwordA = request.form.get("passwordA")
   


    return render_template("signup.html")

@auth.route("/logout")
def logout():
    return redirect(url_for("views.home"))