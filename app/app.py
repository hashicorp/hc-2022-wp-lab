from flask import Flask, render_template
import os
application = Flask(__name__)

osplatform = os.environ.get('PLATFORM')

@application.route("/")
def index():
    return (render_template('index.html', platform=osplatform))

if __name__ == "__main__":
    application.run(host='0.0.0.0')
