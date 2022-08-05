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
        cursor.close()

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
        cursor.close()

        # Check password matching
        if not user or not check_password_hash(user[2], request.form.get("password")):
            return err("Wrong username / password", 400)

        session["user_id"] = user[0]

        flash("Login Successful!")
        return redirect("/")

    return render_template("login.html")


@app.route("/", methods=["GET", "POST"])
@require_login
def index():
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM products WHERE name LIKE %s", ("%" + request.form.get("search_product") + "%",))
        items = cursor.fetchall()

    else:
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM products")
        items = cursor.fetchall()

    cursor.close()

    return render_template("index.html", items=items)


# Display Full Information of the item
@app.route("/items/<int:id>")
@require_login
def item(id):
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM products WHERE id = %s", str(id), )
    product = cursor.fetchone()
    cursor.close()

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
    cursor.close()

    return render_template("cart.html", items_in_cart=items_in_cart)


@app.route("/checkout", methods=["POST"])
@require_login
def checkout():
    cursor = mysql.connection.cursor()

    ids = request.form.getlist("id[]")
    product = request.form.getlist("quantity[]")

    sql = """SELECT * FROM products where id in (""" + ",".join(list(ids)) + """)"""
    cursor.execute(sql)
    prod_checksum = cursor.fetchall()

    # Invalid Item ID
    if len(prod_checksum) != len(ids):
        return err("Invalid Item ID", 400)

    # Invalid Quantity
    for i in range(len(ids)):
        if int(product[i]) <= 0:
            return err("Invalid Quantity of Item", 400)

    # After Successful Payment

    # Create New Order
    cursor.execute(
        "INSERT INTO orders (user_id, order_time) VALUES (%s,%s)", (session["user_id"], datetime.datetime.now(),))

    # Retrieve Newly Generated Order ID
    order_id = cursor.lastrowid

    mysql.connection.commit()

    # order_lists = {}
    # order_lists["id"] = order_id

    # Record Order Lists for the Order
    for i in range(len(ids)):
        cursor.execute("INSERT INTO order_lists (order_id,product_id,quantity,subtotal) VALUES (%s,%s,%s,%s)",
                       (order_id))

        # order_lists[int(ids[i])] = int(product[i])

    return render_template("test.html", test="")


@app.route("/voucher", methods=["GET", "POST"])
@require_login
def voucher():
    if request.method == "POST":
        id = int(request.form.get("id"))
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM vouchers WHERE id = '%s'" % (id))
        voucher = cursor.fetchone()

        # Check validity of voucher
        if not voucher:
            return err("Invalid Voucher", 400)

        # Avoid duplicated voucher
        cursor.execute(
            "SELECT * FROM user_vouchers WHERE user_id = '%s' AND voucher_id = '%s'" % (session["user_id"], id))

        redeemed_voucher = cursor.fetchone()

        if redeemed_voucher:
            return err("You have redeemed this voucher", 400)

        cursor.execute("INSERT INTO user_vouchers (user_id,voucher_id) VALUES (%s,%s)" % (session["user_id"], id,))

        mysql.connection.commit()

        message = "Successfully Redeemed Voucher ID: " + str(id) + "."

        cursor.execute("INSERT INTO notifications (user_id,title,message,notify_time) VALUES (%s,%s,%s,%s)", (
            session["user_id"], "Redeem Voucher", message, datetime.datetime.now(),))

        mysql.connection.commit()
        cursor.close()

        flash("Redeem Voucher Successfully!")

    cursor = mysql.connection.cursor()
    cursor.execute("""
    SELECT * FROM vouchers WHERE start_date <= '%s' AND end_date >= '%s'
    AND NOT id IN (SELECT voucher_id FROM user_vouchers WHERE user_id = '%s')
    """ % (
        datetime.datetime.now(), datetime.datetime.now(), session["user_id"]))
    vouchers = cursor.fetchall()
    cursor.close()

    return render_template("voucher.html", vouchers=vouchers)


@app.route("/notification")
@require_login
def notification():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM notifications WHERE user_id = %s ORDER BY notify_time DESC", (session["user_id"],))
    notifications = cursor.fetchall()
    cursor.close()
    return render_template("notification.html", notifications=notifications)


@app.route("/chat")
@require_login
def chat():
    chats = ""

    return render_template("chat.html", chats="")


@app.route("/ratings")
@require_login
def ratings():
    return render_template("ratings.html", purchases="")


@app.route("/purchase-history")
@require_login
def purchase_history():
    return render_template("purchase-history.html", purchases="")


@app.route("/wallet")
@require_login
def wallet():
    return render_template("wallet.html", wallet="")


@app.route("/settings")
@require_login
def settings():
    return render_template("settings.html", settings="")


@app.route("/change-password")
@require_login
def change_password():
    return render_template("change-password.html")


@app.route("/logout")
@require_login
def logout():
    session.clear()
    flash("You are logged out.")
    return render_template("login.html")
