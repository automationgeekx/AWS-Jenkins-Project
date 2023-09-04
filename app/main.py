from flask import render_template
import os
from app_instance import app

@app.route('/')
def hello_world():
    return render_template('index.html')

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, host='0.0.0.0', port=port)
