from flask import Flask
import sqlite3
import click
from flask import current_app, g
from flask.cli import with_appcontext
from flask import render_template

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
#----------User-------------#
