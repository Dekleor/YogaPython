from flask import Flask
import sqlite3
import click
from flask import current_app, g
from flask.cli import with_appcontext
from flask import render_template
from flask.globals import _request_ctx_stack, request, session
from flask.helpers import flash, url_for
from werkzeug import check_password_hash, generate_password_hash
from flask import redirect

app = Flask(__name__)
#-------DataBase-----------#
DATABASE = 'Python.db'

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('Python.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

@app.cli.command('init-db')
@with_appcontext
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')

def init_app(app):
    app.cli.add_command(init_db_command)

#-----------webPage---------#
@app.route("/")
def index():
    return render_template("home.html")

#---------Register---------#


@app.route('/register/', methods=('GET', 'POST'))
=======
def register():
    """Register function"""
    if request.method == 'POST':
        username = request.form['username']
        lastname = request.form['lastname']
        firstname = request.form['firstname']
        email = request.form['email']
        password = request.form['password']
        db = get_db()
        error = None

        if db.execute(
            'SELECT user_id FROM user WHERE username = ?', (username,)
        ).fetchone() is not None:
            error = 'User {} is already registered.'.format(username)

        if error is None:
            db.execute(
                'INSERT INTO user (username, lastname, '
                + 'firstname, email, password)'
                + 'VALUES (?, ?, ?, ?, ?)',
                (username, lastname, firstname, email,
                generate_password_hash(password)))
            db.commit()
            return redirect(url_for('login'))

        flash(error)

    return render_template('register.html')

#-----------Login-----------#

@app.route('/login/', methods=('GET', 'POST'))
def login():
    """Login"""
    if request.method == 'GET':
        username = request.form['username']
        password = request.form['password']
        db = get_db()
        error = None
        user = db.execute(
            'SELECT * FROM user WHERE username = ?', (username,)
            ).fetchone()

        if user is None:
            error = 'Incorrect username.'
        elif not check_password_hash(user['password'], password):
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['id'] = user['id']
            session['username'] = user['username']
            session['firstname'] = user['firstname']
            session['lastname'] = user['lastname']
            session['email'] = user['email']
            session['password'] = user['password']
            return redirect(url_for('homepage'))

        flash(error)

    return render_template('login.html')

#-----------Logout-----------#
@app.route('/logout')
def logout():
    """deconnection and clear session"""
    session.clear()
    return redirect(url_for('index'))

