from flask import Flask, request, jsonify, make_response
from joblib import load as load_joblib


app = Flask(__name__)
pipeline = load_joblib("models/sentiments.joblib")


@app.route('/', methods=['GET'])
def index():
    return make_response("OK", 200)


@app.route('/predict', methods=['POST'])
def predict():
    
    try:
        request_dict = request.get_json()
                
        vector = pipeline.named_steps.vectorizer.transform([request_dict["message"]])
        prediction = pipeline.named_steps.model.predict(vector)

        res = {"predicted": prediction[0], "metadata": {"model": "Sentiment Analysis pt-BR", "version": 1}}
        
        return make_response(res, 200)
    
    except Exception as e:
        return make_response(str(e), 500)


if __name__ == '__main__':
    
    app.run(host="0.0.0.0", port=5000)
