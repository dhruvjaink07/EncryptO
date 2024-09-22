from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(150), nullable=False)

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        new_user = User(email=email, password=password)
        try:
            db.session.add(new_user)
            db.session.commit()
            return redirect(url_for('success'))
        except Exception as e:
            db.session.rollback()
            return f"An error occurred: {e}"
    return render_template('Signup.html')

@app.route('/success')
def success():
    return "Sign up successful!"

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
