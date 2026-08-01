import time
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

# We now store both the expiration timestamp AND the specific pole ID (if any).
# If pole is None, it means the device is activated on ALL poles.
device_state = {
    'll': {'expire': 0.0, 'pole': None},  # Laser Line
    'sp': {'expire': 0.0, 'pole': None},  # Speaker
    'ws': {'expire': 0.0, 'pole': None}   # Water Sprinkler
}

# How long (in seconds) the device stays ON after being triggered
DURATION = 5.0 

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/state', methods=['GET'])
def get_state():
    """Frontend polls this to update the UI."""
    now = time.time()
    state = {}
    
    for dev, data in device_state.items():
        if now < data['expire']:
            # If a specific pole was targeted, return its ID (as a string).
            # Otherwise, return True to indicate ALL poles.
            state[dev] = data['pole'] if data['pole'] is not None else True
        else:
            state[dev] = False
            
    return jsonify(state)

@app.route('/api/trigger', methods=['POST'])
def trigger():
    """API to turn on a device. Accepts JSON: {"device": "ll", "pole": "3"}"""
    data = request.json
    if not data or 'device' not in data:
        return jsonify({"error": "Invalid request. Send JSON like {'device': 'll'}"}), 400
    
    device = data.get('device')
    # Grab the pole from the JSON payload (defaults to None if missing or empty)
    pole = data.get('pole')
    if pole == "":
        pole = None
    
    if device in device_state:
        # Set the expiration time and the target pole
        device_state[device]['expire'] = time.time() + DURATION
        device_state[device]['pole'] = str(pole) if pole is not None else None
        
        target_msg = f"pole {pole}" if pole is not None else "ALL poles"
        return jsonify({
            "status": "success", 
            "device": device, 
            "pole": pole,
            "message": f"Device '{device}' activated on {target_msg} for {DURATION} seconds."
        })
    else:
        return jsonify({"error": "Invalid device code. Use 'll', 'sp', or 'ws'."}), 400

if __name__ == '__main__':
    app.run(debug=True, port=5001)