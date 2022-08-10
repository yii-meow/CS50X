import datetime

from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from flask_mysqldb import MySQL
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import err, require_login, require_seller_login, myr

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
    # Form Validation
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

        # Set wallet id equivalent to user id
        wallet_id = cursor.lastrowid

        # create new wallet for the user after successful registration
        cursor.execute("INSERT INTO wallets (user_id) VALUES (%s)", (wallet_id,))

        mysql.connection.commit()
        cursor.close()

        # redirect page

        flash("Register Successfully!")
        return render_template("login.html")

    return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    session.clear()

    # Form Validation
    if request.method == "POST":
        if not request.form.get("username"):
            return err("Please provide username", 400)

        if not request.form.get("password"):
            return err("Please provide password", 400)

        cursor = mysql.connection.cursor()

        # Check password matching
        cursor.execute("SELECT * FROM users WHERE username = %s", (request.form.get("username"),))
        user = cursor.fetchone()
        cursor.close()

        if not user or not check_password_hash(user[2], request.form.get("password")):
            return err("Wrong username / password", 400)

        session["user_id"] = user[0]

        flash("Login Successful!")
        return redirect("/")

    return render_template("login.html")


# Main Page where show all product, or searched result by user
@app.route("/", methods=["GET", "POST"])
@require_login
def index():
    if request.method == "POST":
        # Search Product by given name
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM products WHERE name LIKE %s", ("%" + request.form.get("search_product") + "%",))
        items = cursor.fetchall()

    else:
        # Return all products
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM products")
        items = cursor.fetchall()

    cursor.close()
    return render_template("index.html", items=items)


# Display Full Information of the item according to product id
@app.route("/items/<int:id>")
@require_login
def item(id):
    cursor = mysql.connection.cursor()

    # Retrieve Product, and its rating general info
    cursor.execute("""
    SELECT products.id, name,price,description,image,quantity,release_date, ROUND(AVG(ratings.stars),1), COUNT(ratings.product_id),amount_of_sold FROM products
    LEFT JOIN ratings ON products.id = ratings.product_id
    WHERE products.id = %s
    GROUP BY ratings.product_id
    """ % str(id), )
    product = cursor.fetchone()

    # Retrieve all ratings information of the product
    cursor.execute("""
    SELECT ratings.stars, ratings.content, ratings.created_at, users.username FROM ratings
    JOIN users ON ratings.user_id = users.id
    WHERE product_id = %s
    ORDER BY ratings.created_at DESC
    """ % str(id))
    ratings = cursor.fetchall()

    cursor.close()
    return render_template("product.html", product=product, ratings=ratings)


# Cart using session
@app.route("/cart", methods=["GET", "POST"])
@require_login
def cart():
    # Check if cart exists in session
    if "cart" not in session:
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


# Clear cart session after a successful payment
@app.route("/clearitem/<int:id>", methods=["POST"])
@require_login
def clear_item(id):
    session["cart"].pop(str(id))
    return redirect("/cart")


# Checkout after confirming cart
@app.route("/checkout", methods=["POST"])
@require_login
def checkout():
    cursor = mysql.connection.cursor()

    # Retrieve every cart product id, and its quantity
    ids = request.form.getlist("id[]")
    quantity = request.form.getlist("quantity[]")

    sql = """SELECT * FROM products where id in (""" + ",".join(list(ids)) + """)"""
    cursor.execute(sql)
    items_in_cart = cursor.fetchall()

    # Invalid Item ID if the result of item id cannot match the length
    if len(items_in_cart) != len(ids):
        return err("Invalid Item ID", 400)

    # Invalid Quantity
    for i in range(len(ids)):
        if int(quantity[i]) <= 0:
            return err("Invalid Quantity of Item", 400)

        # Out of Stock
        elif int(quantity[i]) > items_in_cart[i][5]:
            return err("No enough stock to buy", 400)

    # Calculate Subtotal
    subtotal = 0
    for i in range(len(ids)):
        # Retrieve the price of the product and add into subtotal
        cursor.execute("SELECT price FROM products WHERE id = %s" % ids[i])
        subtotal += cursor.fetchone()[0] * int(quantity[i])

    # Retrieve vouchers options for the user
    cursor.execute("""
    SELECT * FROM user_vouchers 
    JOIN vouchers ON voucher_id = vouchers.id 
    WHERE user_id = %s
    AND used = 0
    """ % session["user_id"])
    vouchers = cursor.fetchall()

    cursor.close()
    return render_template("payment.html", items_in_cart=items_in_cart, subtotal=subtotal, vouchers=vouchers)


# Page after confirming checkout
@app.route("/payment", methods=["GET", "POST"])
@require_login
def payment():
    # Fee Definition
    shipment_fee = 5.0  # Fixed Shipment Fee
    tax = 0.06  # Fixed Tax Rate
    discount_rate = 1.0  # No Discount Rate (multiply 1=Same Price)

    cursor = mysql.connection.cursor()
    ids = request.form.getlist("id[]")
    quantity = request.form.getlist("quantity[]")

    # Payment Process
    payment_method = request.form.get("payment_method")

    # If payment is not chosen
    if not payment_method:
        return err("Please choose a payment method", 400)

    # Calculate Payment
    subtotal = 0

    # Get the price of every product in cart
    for i in range(len(ids)):
        cursor.execute("SELECT price FROM products WHERE id = %s" % ids[i])
        price = cursor.fetchone()
        subtotal += price[0] * int(quantity[i])

    # Retrieve the voucher which is used in this transaction
    voucher = request.form.get("voucher")

    # Check voucher validity
    if voucher:
        cursor.execute("""
        SELECT * FROM vouchers WHERE id IN
        (SELECT voucher_id FROM user_vouchers 
        WHERE user_id = %s AND voucher_id = %s AND used = 0)
        """, (session["user_id"], int(voucher)))
        voucher_validity = cursor.fetchone()

        # if the user does not have this voucher
        if not voucher_validity:
            return err("Voucher is not available", 400)

        # Check Minimum Spend
        if subtotal >= voucher_validity[4]:
            # If this voucher is for free shipping
            if voucher_validity[2]:
                # Deducts Shipment Fee
                shipment_fee -= voucher_validity[5];

            # If this voucher deducts grand total by percentage
            elif voucher_validity[3]:
                # Redefine Discount Rate Eg: ( 1 - 0.1)
                discount_rate -= float(voucher_validity[5]) / 100

            # If this voucher deducts grand total by fixed amount
            else:
                subtotal -= voucher_validity[5]

        # Set Voucher is used by the user
        cursor.execute("UPDATE user_vouchers SET used = 1 WHERE user_id = %s AND voucher_id = %s",
                       (session["user_id"], int(voucher),))

        # Notification for used vouchers
        message = "Voucher ( " + voucher_validity[1] + " ) has been used."

        cursor.execute("INSERT INTO notifications (user_id,title,message,notify_time) VALUES (%s,%s,%s,%s)", (
            session["user_id"], "Used Voucher", message, datetime.datetime.now(),))

    # Calculate Grand Total by adding voucher, shipment fee, tax
    grand_total = ((subtotal * discount_rate + shipment_fee) * tax) + subtotal * discount_rate + shipment_fee

    if payment_method == "wallet":
        # Check user wallet balance
        cursor.execute("SELECT amount FROM wallets WHERE user_id = %s", (session["user_id"],))
        balance = cursor.fetchone()

        # Insufficient wallet balance validation
        if balance[0] < grand_total:
            return err("Insufficient Balance in wallet", 400)

        cursor.execute("UPDATE wallets SET amount = amount - %s WHERE user_id = %s", (grand_total, session["user_id"],))
        mysql.connection.commit()

    # Create New Order after successful payment
    cursor.execute(
        "INSERT INTO orders (user_id, order_time,grand_total) VALUES (%s,%s,%s)",
        (session["user_id"], datetime.datetime.now(), grand_total))

    mysql.connection.commit()

    # Retrieve Newly Generated Order ID to put in order lists
    order_id = cursor.lastrowid

    # Record Order Lists for the Order
    for i in range(len(ids)):
        cursor.execute("SELECT price FROM products WHERE id = %s" % ids[i])
        price = cursor.fetchone()

        cursor.execute("INSERT INTO order_lists (order_id,product_id,quantity,subtotal) VALUES (%s,%s,%s,%s)",
                       (order_id, (ids[i]), (quantity[i]), price[0] * int(quantity[i])))

        mysql.connection.commit()

        # Update product Quantity and amount of sold
        cursor.execute(
            "UPDATE products SET quantity = quantity - %s, amount_of_sold = amount_of_sold + %s WHERE id = %s",
            (int(quantity[i]), int(quantity[i]), ids[i]), )

        mysql.connection.commit()

    # User Notification
    message = "Payment for Order ID " + str(order_id) + " is successful. We have notified the seller to ship."
    cursor.execute("INSERT INTO notifications (user_id,title,message,notify_time) VALUES (%s,%s,%s,%s)", (
        session["user_id"], "Payment is Successful", message, datetime.datetime.now(),))

    # Seller Notification (Only 1 Seller at this time)
    seller_message = "Order Id: " + str(order_id) + " has been placed."
    cursor.execute("INSERT INTO seller_notifications (seller_id,title,message,notify_time) VALUES (%s,%s,%s,%s)", (
        1, "New Order", seller_message, datetime.datetime.now(),))

    mysql.connection.commit()
    cursor.close()

    # Clear cart
    session["cart"] = {}
    flash("Payment Successful")

    return redirect("/history")


# Let user claim voucher
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
    SELECT * FROM vouchers WHERE '%s' BETWEEN start_date AND end_date
    AND NOT id IN (SELECT voucher_id FROM user_vouchers WHERE user_id = '%s')
    """ % (
        datetime.datetime.now(), session["user_id"]))
    vouchers = cursor.fetchall()
    cursor.close()

    return render_template("voucher.html", vouchers=vouchers)


@app.route("/redeemedVoucher", methods=["GET"])
@require_login
def redeemed_voucher():
    cursor = mysql.connection.cursor()
    cursor.execute("""
    SELECT * FROM vouchers 
    JOIN user_vouchers ON vouchers.id = user_vouchers.voucher_id
    WHERE user_vouchers.user_id = %s
    AND user_vouchers.used = 0
    """, (session["user_id"],))
    vouchers = cursor.fetchall()
    return render_template("redeemedVoucher.html", vouchers=vouchers)


# For user viewing their notifications
@app.route("/notification")
@require_login
def notification():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM notifications WHERE user_id = %s ORDER BY notify_time DESC", (session["user_id"],))
    notifications = cursor.fetchall()
    cursor.close()
    return render_template("notification.html", notifications=notifications)


# For chatting with seller for buyer
@app.route("/chat", methods=["GET", "POST"])
@require_login
def chat():
    if request.method == "POST":
        chat_message = request.form.get("chat_message")
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM chat_lines WHERE user_id = %s" % session["user_id"])
        chat = cursor.fetchone()

        # If there is chat before, insert to the existing chat
        if chat:
            cursor.execute(
                "INSERT INTO chat_lines (chat_id,user_id,line_text,sender,created_at) VALUES (%s,%s,%s,%s,%s)",
                (chat[1], session["user_id"], chat_message, 'buyer', datetime.datetime.now(),))

        else:
            # If there is no chat before, create a new chat
            cursor.execute("INSERT INTO chats VALUES ()")
            mysql.connection.commit()
            chat_id = cursor.lastrowid
            cursor.execute(
                "INSERT INTO chat_lines (chat_id,user_id,line_text,sender,created_at) VALUES (%s,%s,%s,%s,%s)",
                (chat_id, session["user_id"], chat_message, 'buyer', datetime.datetime.now(),))

        mysql.connection.commit()
        cursor.close()

    cursor = mysql.connection.cursor()
    cursor.execute("""SELECT line_text,sender,created_at FROM chat_lines
    WHERE user_id = %s
    """ % session["user_id"])

    chat_messages = cursor.fetchall()

    return render_template("chat.html", chat_messages=chat_messages)


# Post rating for an order list
@app.route("/ratings", methods=["POST"])
@require_login
def ratings():
    if request.method == "POST":
        if not request.form.get("rating"):
            return err("Please provide rating", 400)

        if not request.form.get("ratingContent"):
            return err("Please provide rating content", 400)

        cursor = mysql.connection.cursor()
        cursor.execute("INSERT INTO ratings (product_id,user_id,stars,content,created_at) VALUES (%s,%s,%s,%s,%s)",
                       (request.form.get("product_id"), session["user_id"], request.form.get("rating"),
                        request.form.get("ratingContent"), datetime.datetime.now(),))
        mysql.connection.commit()

        # After rating, set rating of the order list is true
        cursor.execute("UPDATE order_lists SET rated = 1 WHERE order_id = %s AND product_id = %s",
                       (request.form.get("order_id"), request.form.get("product_id"),))

        mysql.connection.commit()
        flash("Rate Successfully!")
        cursor.close()

    return redirect("/userRatings")


# View specific rating from an order list
@app.route("/viewRating/<int:id>", methods=["GET"])
@require_login
def view_rating(id):
    cursor = mysql.connection.cursor()
    cursor.execute("""
    SELECT * FROM ratings
    JOIN products ON ratings.product_id = products.id
    JOIN order_lists ON products.id = order_lists.product_id
    WHERE order_lists.order_id = %s
    AND ratings.user_id = %s
    """ % (id, session["user_id"]))
    ratings = cursor.fetchall()
    cursor.close()
    return render_template("ratings.html", ratings=ratings)


# Check ratings for user
@app.route("/userRatings", methods=["GET", "POST"])
@require_login
def userRatings():
    cursor = mysql.connection.cursor()
    cursor.execute("""
    SELECT * FROM ratings
    JOIN products ON ratings.product_id = products.id
    WHERE user_id = %s
    ORDER BY ratings.created_at DESC
    """ % session["user_id"])
    ratings = cursor.fetchall()
    cursor.close()

    return render_template("ratings.html", ratings=ratings)


# Check purchase history for user
@app.route("/history")
@require_login
def purchase_history():
    cursor = mysql.connection.cursor()

    # Get Order List of the orders by joining the results
    cursor.execute("""SELECT orders.id, orders.grand_total, orders.order_time, orders.shipment_status, products.id, products.name, products.price, products.image, order_lists.quantity,order_lists.rated FROM orders
    JOIN order_lists ON orders.id = order_lists.order_id
    JOIN products ON order_lists.product_id = products.id
    WHERE user_id = %s
    ORDER BY orders.order_time DESC
    """ % session["user_id"], )
    order_lists = cursor.fetchall()

    return render_template("history.html", purchases=order_lists)


# Check wallet amount for user
@app.route("/wallet")
@require_login
def wallet():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT amount FROM wallets WHERE user_id = %s" % session["user_id"], )
    cash_in_wallet = cursor.fetchone()
    cursor.close()
    return render_template("wallet.html", cash_in_wallet=cash_in_wallet)


# Topup wallet amount
@app.route("/topup", methods=["POST"])
@require_login
def topup_wallet():
    cursor = mysql.connection.cursor()

    try:
        cash = int(request.form.get("amount"))
    except ValueError:
        return err("Please Provide A Positive Number", 400)

    if cash <= 0:
        return err("Value cannot be less than 0", 400)

    cursor.execute("UPDATE wallets SET amount = amount + %s WHERE user_id = %s" % (cash, session["user_id"]), )
    mysql.connection.commit()
    cursor.close()

    flash("Topup Successfully!")
    return redirect("/wallet")


# Withdraw cash from wallet
@app.route("/withdrawal", methods=["POST"])
@require_login
def withdrawal_wallet():
    cursor = mysql.connection.cursor()

    try:
        cash = int(request.form.get("amount"))
    except ValueError:
        return err("Please Provide A Positive Number", 400)

    if cash <= 0:
        return err("Value cannot be less than 0", 400)

    cursor.execute("SELECT amount FROM wallets WHERE user_id = %s" % session["user_id"])

    if cash > cursor.fetchone()[0]:
        return err("Insufficient Balance to Withdraw")

    cursor.execute("UPDATE wallets SET amount = amount - %s WHERE user_id = %s" % (cash, session["user_id"]), )
    mysql.connection.commit()
    cursor.close()

    flash("Withdrawal Successfully!")
    return redirect("/wallet")


# Settings page for user
@app.route("/settings", methods=["GET", "POST"])
@require_login
def settings():
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        cursor.execute("UPDATE users SET name = %s, address = %s, phone_number = %s, profile_picture = %s",
                       (request.form.get("name"), request.form.get("address"), request.form.get("phone_number"),
                        request.form.get("profile_picture"))
                       )
        mysql.connection.commit()
        cursor.close()
        flash("Updated Personal Details!")

    cursor = mysql.connection.cursor()
    cursor.execute("SELECT name,address,phone_number, profile_picture FROM users WHERE id = %s ",
                   (session["user_id"],))
    personal_details = cursor.fetchone()
    cursor.close()

    return render_template("settings.html", personal_details=personal_details)


# Changing password
@app.route("/password", methods=["GET", "POST"])
@require_login
def change_password():
    if request.method == "POST":
        # blank password
        if not request.form.get("prev_password") or not request.form.get("password") or not request.form.get(
                "confirmation"):
            return err("Please provide password", 403)

        cursor = mysql.connection.cursor()

        # retrieve previous password of the user
        cursor.execute("SELECT password_hash FROM users WHERE id = %s" % session["user_id"], )

        previous_password = cursor.fetchone()[0]

        # previous password does not match
        if not check_password_hash(previous_password, request.form.get("prev_password")):
            return err("Wrong Previous Password", 403)

        # same with previous password
        if check_password_hash(previous_password, request.form.get("password")):
            return err("Please enter a different password from previous password", 403)

        # password does not match with confirmation
        if not (request.form.get("password") == request.form.get("confirmation")):
            return err("Password does not match with confirmation", 403)

        # update user password
        cursor.execute("UPDATE users SET password_hash = %s WHERE id = %s",
                       (generate_password_hash(request.form.get("password")), session["user_id"],))

        mysql.connection.commit()

        # Notification
        message = "You have changed your password. Doesn't recognize this? Contact Us."

        cursor.execute("INSERT INTO notifications (user_id,title,message,notify_time) VALUES (%s,%s,%s,%s)", (
            session["user_id"], "Change password", message, datetime.datetime.now(),))

        mysql.connection.commit()

        cursor.close()

        flash("Change password successfully!")

    return render_template("password.html")


# Logout and clear session
@app.route("/logout")
@require_login
def logout():
    session.clear()
    flash("You are logged out.")
    return render_template("login.html")


# Login for seller
@app.route("/seller_login", methods=["GET", "POST"])
def seller_login():
    session.clear()

    if request.method == "POST":
        if not request.form.get("username"):
            return err("Please provide username", 400)

        if not request.form.get("password"):
            return err("Please provide password", 400)

        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM seller WHERE username = %s", (request.form.get("username"),))
        seller = cursor.fetchone()
        cursor.close()

        # Check password matching
        if not seller or not (seller[2] == request.form.get("password")):
            return err("Wrong username / password", 400)

        flash("Login Successful!")
        session["seller_login_status"] = True

        return redirect("/adminPortal")

    return render_template("sellerLogin.html")


# Admin (seller) Main Page
@app.route("/adminPortal", methods=["GET"])
@require_seller_login
def admin_portal():
    cursor = mysql.connection.cursor()

    # Get Order List of the orders by joining the results
    cursor.execute("""SELECT orders.id, orders.grand_total, orders.order_time, orders.shipment_status, products.name, products.price, products.image, order_lists.quantity,users.username FROM orders
            JOIN order_lists ON orders.id = order_lists.order_id
            JOIN products ON order_lists.product_id = products.id
            JOIN users ON orders.user_id = users.id
            ORDER BY orders.order_time DESC
            """)
    order_lists = cursor.fetchall()

    return render_template("adminPortal.html", purchases=order_lists)


# Admin Product Page CRUD
@app.route("/adminProduct", methods=["GET", "PUT", "POST", "DELETE"])
@require_seller_login
def admin_product():
    # Create New Product
    if request.method == "POST":
        # Check all the fields are filled
        if not (request.form.get("product_name") and request.form.get("price") and request.form.get(
                "product_description") and request.form.get("product_image") and request.form.get("quantity")):
            return err("Please fill in all the field!", 400)

        # Check price and quantity
        try:
            price = float(request.form.get("price"))
            quantity = int(request.form.get("quantity"))
        except ValueError:
            return err("Please Provide A Valid Number of Price / Quantity", 400)

        if price <= 0 or quantity <= 0:
            return err("Price cannot be less than 0", 400)

        cursor = mysql.connection.cursor()
        cursor.execute(
            "INSERT INTO products (name,price,description,image,quantity,release_date) VALUES (%s,%s,%s,%s,%s,%s)",
            (request.form.get("product_name"), request.form.get("price"), request.form.get("product_description"),
             request.form.get("product_image"), request.form.get("quantity"), datetime.datetime.now(),))

        mysql.connection.commit()
        cursor.close()
        flash("Created Product Successfully!")

    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM products")
    products = cursor.fetchall()

    return render_template("adminProduct.html", products=products)


# Admin Update Product
@app.route("/updateProduct", methods=["POST"])
@require_seller_login
def update_product():
    # Check all the fields are filled
    if not (request.form.get("product_name") and request.form.get("price") and request.form.get(
            "product_description") and request.form.get("product_image") and request.form.get("quantity")):
        return err("Please fill in all the field!", 400)

    # Check price and quantity
    try:
        price = float(request.form.get("price"))
        quantity = int(request.form.get("quantity"))
    except ValueError:
        return err("Please Provide A Valid Number of Price / Quantity", 400)

    if price <= 0 or quantity <= 0:
        return err("Price cannot be less than 0", 400)

    cursor = mysql.connection.cursor()

    cursor.execute("""
        UPDATE products 
        SET name = %s, price = %s, description = %s, image = %s, quantity = %s
        WHERE id = %s
    """, (request.form.get("product_name"), price,
          request.form.get("product_description"),
          request.form.get("product_image"), quantity, request.form.get("product_id")))

    mysql.connection.commit()
    cursor.close()
    flash("Updated Product Successfully!")
    return redirect("/adminProduct")


# Admin Delete Product
@app.route("/deleteProduct", methods=["POST"])
@require_seller_login
def delete_product():
    cursor = mysql.connection.cursor()

    # product cannot be deleted due to foreign key integrity
    try:
        cursor.execute("DELETE FROM products WHERE id = %s" % request.form.get("id"))
    except:
        return err("Product cannot be deleted.", 400)

    mysql.connection.commit()
    cursor.close()
    flash("Delete Product Successfully!")
    return redirect("/adminProduct")


# Admin Chat with user
@app.route("/adminChat", methods=["GET", "POST"])
@app.route("/adminChat/<int:id>", methods=["GET", "POST"])
@require_seller_login
def admin_chat_id(id=1):
    if request.method == "POST":
        # Send Message
        chat_message = request.form.get("chat_message")
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM chat_lines WHERE user_id = %s" % id)
        chat = cursor.fetchone()

        # If there is chat before, insert to the existing chat
        if chat:
            cursor.execute(
                "INSERT INTO chat_lines (chat_id,user_id,line_text,sender,created_at) VALUES (%s,%s,%s,%s,%s)",
                (chat[1], id, chat_message, 'seller', datetime.datetime.now(),))

        else:
            # If there is no chat before, create a new chat
            cursor.execute("INSERT INTO chats VALUES ()")
            mysql.connection.commit()
            chat_id = cursor.lastrowid
            cursor.execute(
                "INSERT INTO chat_lines (chat_id,user_id,line_text,sender,created_at) VALUES (%s,%s,%s,%s,%s)",
                (chat_id, id, chat_message, 'seller', datetime.datetime.now(),))

        mysql.connection.commit()
        cursor.close()

    cursor = mysql.connection.cursor()
    cursor.execute("""SELECT line_text,sender,created_at,user_id FROM chat_lines
        WHERE user_id = %s
        """ % id)
    chat_messages = cursor.fetchall()

    cursor.execute("""
        SELECT DISTINCT(users.username),users.id FROM chats
        JOIN chat_lines ON chats.id = chat_lines.chat_id
        JOIN users On chat_lines.user_id = users.id
        ORDER BY chat_lines.created_at DESC
        """)
    chat_users = cursor.fetchall()
    cursor.close()

    return render_template("adminChat.html", chat_users=chat_users, chat_messages=chat_messages)


# Admin Notifications Page
@app.route("/adminNotification", methods=["GET"])
@require_seller_login
def admin_notification():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM seller_notifications ORDER BY notify_time DESC")
    notifications = cursor.fetchall()

    return render_template("adminNotification.html", notifications=notifications)


# Admin Voucher CRUD
@app.route("/adminVoucher", methods=["GET", "POST"])
@require_seller_login
def admin_voucher():
    if request.method == "POST":
        # Ensure all fields are filled up
        if not (request.form.get("voucher_name") and request.form.get("min_spend") and request.form.get(
                "is_shipment") and request.form.get("by_percentage") and request.form.get(
            "deduct_amount") and request.form.get("start_date") and request.form.get("end_date")):
            return err("Please fill in all the fields", 400)

        # Positive number field validation
        try:
            min_spend = float(request.form.get("min_spend"))
            deduct_amount = float(request.form.get("deduct_amount"))
        except ValueError:
            return err("Please Provide A Valid Number of Minimum Spend / Deduct Amount", 400)

        if min_spend <= 0 or deduct_amount <= 0:
            return err("Price cannot be less than 0", 400)

        # Provided radio options is not y/n
        if request.form.get("is_shipment") not in ("y", "n") or request.form.get("by_percentage") not in ("y", "n"):
            return err("Is Shipment / By Percentage is not a valid option", 400)

        if request.form.get("is_shipment") == 'y':
            is_shipment = 1
        else:
            is_shipment = 0

        if request.form.get("by_percentage") == 'y':
            by_percentage = 1
        else:
            by_percentage = 0

        # Start date larger than end date
        if request.form.get("start_date") > request.form.get("end_date"):
            return err("Start Date must not be larger than end date", 400)

        cursor = mysql.connection.cursor()
        cursor.execute(
            "INSERT INTO vouchers (name,is_shipment,by_percentage,minimum_spend,deduct_amount,start_date,end_date) VALUES (%s,%s,%s,%s,%s,%s,%s)",
            (request.form.get("voucher_name"), request.form.get("is_shipment"), request.form.get("by_percentage"),
             min_spend, deduct_amount, request.form.get("start_date"), request.form.get("end_date")))

        mysql.connection.commit()
        flash("Successfully Created Voucher!")
        cursor.close()

    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM vouchers ORDER BY end_date")
    vouchers = cursor.fetchall()
    cursor.close()

    return render_template("adminVoucher.html", vouchers=vouchers)


@app.route("/deleteVoucher", methods=["POST"])
@require_seller_login
def delete_voucher():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM vouchers WHERE id = %s", (request.form.get("id"),))
    voucher = cursor.fetchone()

    if not voucher:
        return err("Voucher does not exists.", 400)

    cursor.execute("DELETE FROM vouchers WHERE id = %s", (request.form.get("id"),))
    flash("Successfully deleted voucher!")
    return redirect("/adminVoucher")


# Admin Update Shipment Status
@app.route("/shipmentStatus", methods=["POST"])
@require_seller_login
def change_shipment_status():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM orders WHERE id = %s" % (request.form.get("order_id")))
    order = cursor.fetchone()

    # If order id does not exist
    if not order:
        return err("Order Id does not exists.", 400)

    # Update Shipment Status
    cursor.execute("UPDATE orders SET shipment_status = %s WHERE id = %s", (
        request.form.get("shipment_status"), request.form.get("order_id"),))

    # Update Shipment Time
    if request.form.get("shipment_status") == "Shipping":
        cursor.execute("UPDATE orders SET shipment_time = %s WHERE id = %s",
                       (datetime.datetime.now(), request.form.get("order_id")))

    elif request.form.get("shipment_status") == "Delivered":
        cursor.execute("UPDATE orders SET delivered_time = %s WHERE id = %s",
                       (datetime.datetime.now(), request.form.get("order_id")))

    mysql.connection.commit()
    cursor.close()
    flash("Update Shipment Successfully!")

    return redirect("/adminPortal")


# Admin Check Ratings
@app.route("/adminRatings", methods=["GET"])
@require_seller_login
def admin_ratings():
    cursor = mysql.connection.cursor()
    cursor.execute("""
    SELECT * FROM ratings
    JOIN products ON ratings.product_id = products.id
    ORDER BY ratings.created_at DESC
    """)
    ratings = cursor.fetchall()

    return render_template("adminRatings.html", ratings=ratings)
