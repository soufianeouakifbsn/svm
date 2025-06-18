#!/bin/bash

# إيقاف أي ngrok قديم يعمل على نفس المنفذ
echo "🛑 Killing any previous ngrok processes..."
pkill -f "ngrok http" || true

# تثبيت ngrok (مرة واحدة فقط)
if ! command -v ngrok &> /dev/null; then
  echo "⬇️ Installing ngrok..."
  wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  sudo tar xvzf ./ngrok.tgz -C /usr/local/bin
fi

# تثبيت jq (للتحقق من الرابط)
sudo apt install -y jq

# بيانات ngrok
token="2ydu6xnFE745us2CHwUkj3AAjUe_7QBXqRsTdNKYh76JJZfK2"
domain="talented-fleet-monkfish.ngrok-free.app"

# تأكيد تشغيل الخدمة على المنفذ المطلوب (مثلاً 3123)
port=3123

# التحقق من أن الخدمة تعمل فعليًا على localhost:$port
if ! nc -z localhost $port; then
  echo "❌ لا توجد خدمة تعمل على localhost:$port. تحقق من أن الحاوية تعمل!"
  exit 1
fi

# إضافة التوكن
ngrok config add-authtoken "$token"

# تشغيل ngrok على api port مختلف لتفادي التداخل
ngrok http --domain="$domain" --web-addr=:4041 $port > /dev/null &

# الانتظار قليلاً ثم جلب الرابط
echo "⏳ Waiting for ngrok to initialize..."
sleep 8

EXTERNAL_IP="$(curl -s http://localhost:4041/api/tunnels | jq -r '.tunnels[0].public_url')"
echo "✅ Ngrok tunnel is live: $EXTERNAL_IP"
