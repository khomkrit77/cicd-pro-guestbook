from flask import Flask, request, render_template, redirect, url_for # เพิ่ม redirect และ url_for
import redis

app = Flask(__name__)
r = redis.Redis(host='redis', port=6379, decode_responses=True)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        user_msg = request.form.get('msg')
        if user_msg:
            r.rpush('guestbook_keys', user_msg)
        # --- จุดสำคัญ: หลังจากเซฟเสร็จ ให้สั่งเด้งกลับไปหน้าแรกด้วย GET ---
        return redirect(url_for('index'))
    
    messages = r.lrange('guestbook_keys', 0, -1)
    return render_template('index.html', messages=messages)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
