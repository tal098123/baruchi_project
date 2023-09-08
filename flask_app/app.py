from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://tal:tal@10.0.0.10/flask_db'  # Update with your PostgreSQL credentials
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:mysecretpassword@localhost/flask_db'  # Update with your PostgreSQL credentials
db = SQLAlchemy(app)

class Animal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    species = db.Column(db.String(80), nullable=False)


@app.route('/')
def index():
    animals = Animal.query.all()
    return render_template('index.html', animals=animals)

@app.route('/add', methods=['POST'])
def add_animal():
    
    name = request.form['name']
    species = request.form['species']

    new_animal = Animal(name=name, species=species)
    db.session.add(new_animal)
    db.session.commit()

    return redirect(url_for('index'))

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        app.run(host="localhost", port=8080)
