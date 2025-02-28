from flask import Flask, request, jsonify, redirect
from flask_cors import CORS
import stripe
import os

# Flask 앱 초기화
app = Flask(__name__)
# CORS 설정 추가 (모든 출처 허용)
CORS(app)

# Stripe API 키 설정 (실제 키로 변경 필요)
stripe.api_key = ""

# 루트 페이지
@app.route('/', methods=['GET'])
def index():
    return "Hello, World!"

# 결제 페이지 생성 API
@app.route('/create-checkout-session', methods=['POST', 'GET'])
def create_checkout_session():
    try:
        # 체크아웃 세션 생성
        print("체크아웃 세션 생성")
        checkout_session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[
                {
                    'price_data': {
                        'currency': 'usd',
                        'product_data': {
                            'name': '테스트 상품',
                        },
                        'unit_amount': 1099, 
                    },
                    'quantity': 1,
                },
            ],
            mode='payment',
            success_url='http://localhost:5000/success',
            cancel_url='http://localhost:5000/cancel',
        )
        
        # 체크아웃 페이지로 리다이렉트
        return jsonify({"id": checkout_session.id, "url": checkout_session.url})
        
    except Exception as e:
        return jsonify(error=str(e)), 400

# 성공 페이지
@app.route('/success', methods=['GET'])
def success():
    return "결제가 성공적으로 완료되었습니다!"

# 취소 페이지
@app.route('/cancel', methods=['GET'])
def cancel():
    return "결제가 취소되었습니다."

# 웹훅 처리 (결제 완료 이벤트 등 수신)
@app.route('/webhook', methods=['POST'])
def webhook():
    payload = request.data
    sig_header = request.headers.get('Stripe-Signature')

    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, "whsec_your_webhook_secret"
        )
        
        # 결제 완료 이벤트 처리
        if event['type'] == 'checkout.session.completed':
            session = event['data']['object']
            print(f"결제 완료! 세션 ID: {session['id']}")
            
        return jsonify(success=True)
    except Exception as e:
        return jsonify(error=str(e)), 400

if __name__ == '__main__':
    # 포트 5000에서 실행 (ngrok이 이 포트를 외부에 노출)
    app.run(port=3000, host='0.0.0.0', debug=True)