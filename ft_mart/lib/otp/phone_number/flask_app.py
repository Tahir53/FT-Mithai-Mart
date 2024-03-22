from flask import Flask, request, jsonify
from flask_cors import CORS
from twilio.rest import Client

# Twilio credentials
account_sid = ''
auth_token = ''
twilio_client = Client(account_sid, auth_token)

# Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Endpoint for sending SMS
@app.route('/send-sms', methods=['GET'])
def send_sms():
    try:
        # Extract message and phone number from request
        message_body = request.args.get('message')
        phone_body = request.args.get('phone')
        print(message_body)
        print("good")
        # to_number = data.get('to')

        # Send SMS using Twilio client
        message = twilio_client.messages.create(
            body=message_body,
            to= '+' + phone_body,
            from_='+15642224937'  # Your Twilio phone number
        )

        # Return Twilio message SID
        return jsonify({'message_sid': message.sid}), 200
    except Exception as e:
        # Return error message if sending SMS fails
        return jsonify({'error': str(e)}), 500

@app.route('/test')
def test():
    return jsonify({'message': 'Hello, World!'})

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)
