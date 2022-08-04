import datetime

from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from flask_mysqldb import MySQL
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import err, require_login, myr

# Configure Application
app = Flask(__name__)

# database configuration
app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = ""
app.config['MYSQL_DB'] = "yimmerce"
mysql = MySQL(app)

# Auto Reload File
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Filter Currency
app.jinja_env.filters["myr"] = myr

# Session
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        if not request.form.get("username"):
            return err("Please provide username", 400)

        if not request.form.get("email"):
            return err("Please provide email", 400)

        if not request.form.get("password") or not request.form.get("confirmation_password"):
            return err("Please provide password", 400)

        if request.form.get("password") != request.form.get("confirmation_password"):
            return err("Passwords are not matched", 400)

        if not request.form.get("DOB"):
            return err("Please provide date of birth", 400)

        if not request.form.get("gender"):
            return err("Please provide gender", 400)

        # check if username exists in database
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM users WHERE username = %s", (request.form.get("username"),))
        user = cursor.fetchone()

        # return error if username exists
        if user:
            return err("Username is already exists", 400)

        # check if email exists in database
        cursor.execute("SELECT * FROM users WHERE email = %s", (request.form.get("email"),))
        user_email = cursor.fetchone()

        # return error if email exists
        if user_email:
            return err("Email is already exists", 400)

        # insert new user into db
        value = (
            request.form.get("username"), generate_password_hash(request.form.get("password")),
            request.form.get("email"),
            request.form.get("gender"), request.form.get("DOB"), datetime.datetime.now(),)

        cursor.execute(
            "INSERT INTO users (username,password_hash,email,gender,DOB,registered_date) VALUES (%s,%s,%s,%s,%s,%s)",
            value)

        mysql.connection.commit()

        # redirect page
        flash("Register Successfully!")
        return render_template("login.html")

    return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    session.clear()

    if request.method == "POST":
        if not request.form.get("username"):
            return err("Please provide username", 400)

        if not request.form.get("password"):
            return err("Please provide password", 400)

        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM users WHERE username = %s", (request.form.get("username"),))
        user = cursor.fetchone()

        # Check password matching
        if not user or not check_password_hash(user[2], request.form.get("password")):
            return err("Wrong username / password", 400)

        session["user_id"] = user[0]

        flash("Login Successful!")
        return redirect("/")

    return render_template("login.html")


@app.route("/")
@require_login
def index():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM products")
    items = cursor.fetchall()

    return render_template("index.html", items=items)


@app.route("/shop", methods=["GET", "POST"])
@require_login
def shop():
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM products WHERE name LIKE %s", ("%" + request.form.get("search_product") + "%",))
        items = cursor.fetchall()
        return render_template("shop.html", items=items)

    return render_template("search.html")


# Display Full Information of the item
@app.route("/items/<int:id>")
@require_login
def item(id):
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM products WHERE id = %s", str(id), )
    product = cursor.fetchone()

    return render_template("product.html", product=product)


@app.route("/cart", methods=["GET", "POST"])
@require_login
def cart():
    # Check if cart exists in session
    if "cart" not in session:
        # session["cart"] = []
        session["cart"] = {}
        flash("No item in your cart")
        return render_template("cart.html")

    # Add item to cart
    if request.method == "POST":
        id = (request.form.get("id"))
        if id:
            if id in session["cart"]:
                session["cart"][id] += int(request.form.get("quantity"))
            else:
                session["cart"][id] = int(request.form.get("quantity"))
        return redirect("/cart")

    # Check if cart is empty
    if len(session["cart"]) == 0:
        flash("No item in your cart")
        return render_template("cart.html")

    cursor = mysql.connection.cursor()

    # Should change this to tuple to avoid sql injection, but no idea
    sql = """SELECT * FROM products where id in (""" + ",".join(list(session["cart"])) + """)"""
    cursor.execute(sql)

    items_in_cart = cursor.fetchall()

    return render_template("cart.html", items_in_cart=items_in_cart)


@app.route("/voucher")
def voucher():
    return render_template("voucher.html", vouchers="")


@app.route("/notification")
def notification():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM notifications WHERE user_id = %s ORDER BY time", (session["user_id"],))
    notifications = cursor.fetchall()
    return render_template("notification.html", notifications=notifications)


@app.route("/chat")
def chat():
    chats = ""

    return render_template("chat.html", chats="")


@app.route("/ratings")
def ratings():
    return render_template("ratings.html", purchases="")


@app.route("/purchase-history")
def purchase_history():
    return render_template("purchase-history.html", purchases="")


@app.route("/wallet")
def wallet():
    return render_template("wallet.html", wallet="")


@app.route("/settings")
def settings():
    return render_template("settings.html", settings="")


@app.route("/change-password")
def change_password():
    return render_template("change-password.html")


@app.route("/logout")
def logout():
    session.clear()
    flash("You are logged out.")
    return render_template("login.html")
