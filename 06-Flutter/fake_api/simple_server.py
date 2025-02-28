from flask import Flask, request, jsonify, redirect
from flask_cors import CORS
import stripe
import os

# Flask 앱 초기화
app = Flask(__name__)
# CORS 설정 추가 (모든 출처 허용)
CORS(app)

# Stripe API 키 설정 (실제 키로 변경 필요)
stripe.api_key = "sk_test_51NDpRJJinXpHIPsEd1TV46fvAOsK1wyU4ZDgX0bKPzOyqgvqQhhes8e3qhGCovhFX6a1UIW5jq5D3taGbqRgeoVi00NhNW5otY"

# 루트 페이지
@app.route('/', methods=['GET'])
def index():
    return "Hello, World!"

# 결제 페이지 생성 API
@app.route('/create-payment-intent', methods=['POST', 'GET'])
def create_payment_intent():
    print("요청 메소드:", request.method)
    print("요청 헤더:", request.headers)
    
    # GET 요청 처리
    if request.method == 'GET':
        return jsonify({"message": "GET 요청이 성공적으로 처리되었습니다. POST 요청을 사용하여 Payment Intent를 생성하세요."})
    
    try:
        # Payment Intent 생성
        payment_intent = stripe.PaymentIntent.create(
            amount=10000,  # 100원 (KRW는 소수점 없음)
            currency='krw',
            payment_method_types=['card'],
            description='테스트 상품 결제',
            metadata={'integration_check': 'accept_a_payment'},
        )
        
        # Payment Intent 정보 반환
        return jsonify({
            'clientSecret': payment_intent.client_secret,
            'id': payment_intent.id,
            'amount': payment_intent.amount,
            'currency': payment_intent.currency
        })
        
    except Exception as e:
        print("에러 발생:", str(e))
        return jsonify(error=str(e)), 400
        
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