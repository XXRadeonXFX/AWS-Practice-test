from flask import Flask
import redis
import os

app = Flask(__name__)
#redis_client = redis.Redis(host=os.environ.get('REDIS_HOST' , 'redis' ), port=6379 )
redis_client = redis.Redis(host='127.0.0.1', port=6379)


@app.route('/')
def func():
    visit_count =  redis_client.incr('visits')
    return  f'Hello this page is visited {visit_count} times.'

if __name__ == '__main__':
    app.run(host= '0.0.0.0' , debug=True, port = 3000)