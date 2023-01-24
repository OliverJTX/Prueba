from flask import Flask,render_template
import datetime  
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

@app.route("/parell/<int:numero>")  
def paresimpares(numero):
    if numero % 2 == 0:
        return f'El numero {numero} es par'
    else:
        return f'El numero {numero} es impar'

@app.route('/hello/')
@app.route('/hello/<name>')
def hello_transplate(name=None):
    return render_template('hello.html', name=name)

@app.route('/edad/<name>/<int:edad>')
def edad_transplate(name=None, edad=int):
    fecha = datetime.datetime.now()

    Años_n = 100 - edad
    BithKevuin = fecha.year + Años_n
    return render_template('hello.html', name=name, BithKevuin = str(BithKevuin))
