from flask import Flask ,redirect , Blueprint ,render_template ,current_app, g
import sqlite3
import click
from flask.cli import with_appcontext
from flask.globals import _request_ctx_stack, request, session
from flask.helpers import flash, url_for
from werkzeug import check_password_hash, generate_password_hash
from werkzeug.security import check_password_hash
<<<<<<< HEAD
=======
from flask import redirect
>>>>>>> main

app = Flask(__name__, instance_relative_config=True)

app.config.update(
    TESTING=True,
    SECRET_KEY='192b9bdd22ab9ed4d12e236c78afcb9a393ec15f71bbf5dc987d54727823bcbf'
)
#-------DataBase-----------#
DATABASE = 'Python.db'

bp = Blueprint('auth', __name__, url_prefix='auth')



app = Flask(__name__)

# Creating connection with SQLite db
def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect(
            "Python.db",
            detect_types=sqlite3.PARSE_DECLTYPES
        )
        g.db.row_factory = sqlite3.Row

    return g.db

# add Python functions that will run these SQL commands
def init_db():
    db = get_db()

    with current_app.open_resource('Python.sql') as f:
        db.executescript(f.read().decode('utf8'))

@click.command('init-db')
@with_appcontext
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')

# closed after the work is finished
def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()

# call that function
app.teardown_appcontext(close_db)
# adds a new command that can be called with the flask command
app.cli.add_command(init_db_command)



#-----------webPage---------#
@app.route("/")
def home():
    return render_template("home.html")


#---------Register---------#


@app.route('/register/', methods=('GET', 'POST'))
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
            'SELECT id FROM user WHERE username = ?', (username,)
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
            return render_template('home.html')
            
        flash(error)

    return render_template('./other/register.html')

#-----------Login-----------#

@app.route('/login/', methods=('GET', 'POST'))
def login():
    """Login"""
    if request.method == 'POST':
        username = request.form['username']
        password = generate_password_hash(request.form['password'])
        db = get_db()
        error = None
        user = db.execute(
            'SELECT * FROM user WHERE username = ?', (username,)
            ).fetchone()
        return render_template('home.html')

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

            return render_template('home.html')

        flash(error)

    return render_template('./other/login.html')


@app.route('/logout')
def logout():
    """deconnection and clear session"""
    session.clear()
    return render_template('home.html')

#-----------CRUD-POST--------------#

@app.route('/pose', methods=['GET','POST'])
def add_pose():
    if request.method == 'POST':
        name = request.form['name']
        description = request.form['description']
        photo = request.form['photo']
        if not content:
            return 'Error'

        poseName = pose(name)
        poseDesc = pose(description)
        db.session.add(poseName , poseDesc)
        db.session.commit()

    return render_template('./other/pose.html')

@app.route('/pose/edit/<int:pose_id>', methods=['GET','POST'])
def edit_pose():
    if request.method == 'POST':
        name = request.form['name']
        description = request.form['description']
        photo = request.form['photo']
        if not content:
            return 'Error'

        poseName = pose(name)
        poseDesc = pose(description)
        db.session.add(poseName , poseDesc)
        db.session.commit()

    return render_template('./other/pose.html')

@app.route('/delete/<int:pose_id>')
def delete_pose(pose_id):
    pose = pose.query.get(pose_id)
    if not pose:
        return redirect('/')

    db.session.delete(pose)
    db.session.commit()
    return redirect('/')


@app.route('/done/<int:pose_id>')
def resolve_pose(pose_id):
    pose = pose.query.get(pose_id)

    if not pose:
        return redirect('/')
    if pose.done:
        pose.done = False
    else:
        pose.done = True

    db.session.commit()
    return redirect('/')


if __name__ == '__main__':
    app.run(debug=True)
