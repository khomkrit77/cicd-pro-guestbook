# 1. ใช้ Base Image ที่เป็น Nginx เวอร์ชัน Alpine เพื่อความเล็กและปลอดภัย
FROM nginx:alpine

# 2. ติดตั้ง curl หรือเครื่องมือที่จำเป็น (เผื่อใช้ตรวจสอบสถานะภายในคอนเทนเนอร์)
RUN apk update && apk upgrade && apk add --no-cache curl

# 3. ลบไฟล์เริ่มต้นของ Nginx ออกเพื่อให้แน่ใจว่าไม่มีไฟล์ขยะค้างอยู่
RUN rm -rf /usr/share/nginx/html/*

# 4. คัดลอกไฟล์ทั้งหมดจากโปรเจกต์ (รวมถึง index.html) เข้าไปในโฟลเดอร์ของ Nginx
COPY . /usr/share/nginx/html/

# 5. เปิด Port 80 สำหรับรับ Web Traffic (เป็นมาตรฐานของ Nginx)
EXPOSE 80

# 6. สั่งให้ Nginx รันแบบ Foreground (เพื่อให้ Container ไม่ดับ)
CMD ["nginx", "-g", "daemon off;"]
