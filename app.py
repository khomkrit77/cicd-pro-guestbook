from flask import Flask, request, render_template
import redis
import os

app = Flask(__name__)

# เชื่อมต่อกับ Redis (ใช้ชื่อ service 'redis' จาก docker-compose)
r = redis.Redis(host='redis', port=6379, decode_responses=True)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        user_msg = request.form.get('msg')
        if user_msg:
            # Append ข้อมูลลงใน List ของ Redis ชื่อ 'guestbook_keys'
            r.rpush('guestbook_keys', user_msg)
    
    # ดึงข้อมูลทั้งหมดจาก Redis มาแสดง
    messages = r.lrange('guestbook_keys', 0, -1)
    
    return render_template('index.html', messages=messages)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
