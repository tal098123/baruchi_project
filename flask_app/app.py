from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://tal:tal@10.0.0.10/flask_db'  # Update with your PostgreSQL credentials
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:mysecretpassword@localhost/flask_db'  # Update with your PostgreSQL credentials
db = SQLAlchemy(app)

class Encrypted_text_db(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text, nullable=False)

class Decrypted_text_db(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text, nullable=False)

def encrypt(message):
    conversion_table = str.maketrans("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890אבגדהוזחטיכלמנסעפצקרשת",
     "zyxwvuאבזחטיכ349לקרשתtsrqpo120nmlkjihgfedcbaZYמנסע56פצXWVUTSRQPONMLגדהוK78JIHרשGFEDCBA")
    return message.translate(conversion_table)


def decrypt(message):
    conversion_table = str.maketrans("zyxwvuאבזחטיכ349לקרשתtsrqpo120nmlkjihgfedcbaZYמנסע56פצXWVUTSRQPONMLגדהוK78JIHרשGFEDCBA", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890אבגדהוזחטיכלמנסעפצקרשת")
    return message.translate(conversion_table)
  

@app.route('/')
def index():
    Encrypted_text_db=Encrypted_text_db.query.all()
    Decrypted_text_db=Decrypted_text_db.query.all()
    return render_template('index.html', Encrypted_text_db=Encrypted_text_db, Decrypted_text_db=Decrypted_text_db)

@app.route('/send_coder', methods=['POST'])
def add_encrypted_text():
    
    encrypted_text = encrypt(str(request.form['text']))

    new_encrypted_text = Encrypted_text_db(text=encrypted_text)
    db.session.add(new_encrypted_text)
    db.session.commit()

    return redirect(url_for('index'))

@app.route('/send_decoder', methods=['POST'])
def add_decrypted_text():
    
    decrypted_text = decrypt(str(request.form['encrypted_text']))

    new_decrypted_text = Decrypted_text_db(text=decrypted_text)
    db.session.add(new_decrypted_text)
    db.session.commit()

    return redirect(url_for('index'))

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        app.run(host="0.0.0.0", port=8080)
