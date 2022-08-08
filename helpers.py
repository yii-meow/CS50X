from flask import render_template, request, session, redirect
from functools import wraps

def err(message, code=400):
    def escape(s):
        for old, new in [("-", "--"), (" ", "-"), ("_", "__"), ("?", "~q"),
                         ("%", "~p"), ("#", "~h"), ("/", "~s"), ("\"", "''")]:
            s = s.replace(old, new)
        return s

    return render_template("error.html", top=code, bottom=escape(message)), code


def require_login(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            return redirect("/login")
        return f(*args, **kwargs)

    return decorated_function


def require_seller_login(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("seller_login_status") is None:
            return redirect("/seller_login")
        return f(*args,**kwargs)

    return decorated_function


def myr(value):
    return f"RM {value:,.2f}"
