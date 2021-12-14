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
    return render_template("index.html")

#----------Login-------------#



# login nom du champ = username et mot de passe nom du champ password 
@app.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        login = request.form['username']
        mdp = _request_ctx_stack.form['password']
        db = get_db()
        error = None

        if not login:
            error = 'Username is required.'
        elif not mdp:
            error = 'Password is required.'

        if error is None:
            try:
                db.execute(
                    "INSERT INTO Participant (login, mdp) VALUES (?, ?)",
                    (login, generate_password_hash(mdp)),
                )
                db.commit()
            except db.IntegrityError:
                error = f"User {login} is already registered."
            else:
                return redirect(url_for("login"))

        flash(error)

    return render_template('register.html')

# login nom du champ = username et mot de passe nom du champ password 
@app.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        login = request.form['Username']
        mdp = request.form['Password']
        db = get_db()
        error = None
        user = db.execute(
            'SELECT * FROM Participant WHERE login = ?', (login,)
        ).fetchone()

        if user is None:
            error = 'Incorrect username.'
        elif not check_password_hash(user['mdp'], mdp):
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['user_id'] = user['id']
            return redirect(url_for('index'))

        flash(error)

    return render_template('login.html')