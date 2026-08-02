# import os
# import cv2
# import base64
# import numpy as np
# import sqlite3
# from datetime import datetime
# from flask import Flask, render_template, request, Response, jsonify
# from werkzeug.utils import secure_filename
# from ultralytics import YOLO

# app = Flask(__name__)
# app.config['UPLOAD_FOLDER'] = 'uploads'
# os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# def init_db():
#     with sqlite3.connect('detections.db') as conn:
#         c = conn.cursor()
#         # Added pole_id to schema
#         c.execute('''CREATE TABLE IF NOT EXISTS detections
#                      (session_id TEXT PRIMARY KEY, 
#                       source TEXT,
#                       pole_id TEXT,
#                       summary TEXT, 
#                       timestamp TEXT)''')
#         conn.commit()

# init_db()

# model = YOLO("yolov8n.pt")
# RELEVANT_CLASSES = {"person", "dog", "cat", "cow", "horse", "sheep", "bird", "elephant", "bear"}

# def update_db(session_id, source_type, pole_id, counts_dict):
#     if not counts_dict:
#         summary = "None detected"
#     else:
#         summary = ", ".join([f"{count}x {animal}" for animal, count in counts_dict.items()])

#     timestamp = datetime.now().isoformat(timespec="seconds")

#     with sqlite3.connect('detections.db', timeout=10) as conn:
#         c = conn.cursor()
#         c.execute("SELECT session_id FROM detections WHERE session_id = ?", (session_id,))
#         if c.fetchone():
#             c.execute("UPDATE detections SET summary = ?, timestamp = ?, pole_id = ? WHERE session_id = ?",
#                       (summary, timestamp, pole_id, session_id))
#         else:
#             c.execute("INSERT INTO detections (session_id, source, pole_id, summary, timestamp) VALUES (?, ?, ?, ?, ?)",
#                       (session_id, source_type, pole_id, summary, timestamp))
#         conn.commit()
        
        
# def process_frame(frame, conf_threshold=0.5):
#     """Runs YOLO, draws boxes, and returns the frame + counts for this specific frame."""
#     results = model.predict(frame, conf=conf_threshold, verbose=False)
#     frame_counts = {}
    
#     for result in results:
#         for box in result.boxes:
#             class_id = int(box.cls[0])
#             class_name = model.names[class_id]

#             if class_name not in RELEVANT_CLASSES:
#                 continue

#             confidence = float(box.conf[0])
#             x1, y1, x2, y2 = map(int, box.xyxy[0])

#             cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
#             label = f"{class_name} {confidence:.2f}"
#             cv2.putText(frame, label, (x1, max(y1 - 10, 0)),
#                         cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

#             # Tally counts for this frame
#             frame_counts[class_name] = frame_counts.get(class_name, 0) + 1

#     return frame, frame_counts

# def generate_frames(source, session_id, source_type, pole_id):
#     cap = cv2.VideoCapture(source)
#     session_max_counts = {}

#     update_db(session_id, source_type, pole_id, session_max_counts)

#     while True:
#         success, frame = cap.read()
#         if not success:
#             break
        
#         frame, frame_counts = process_frame(frame)
        
#         changed = False
#         for animal, count in frame_counts.items():
#             if count > session_max_counts.get(animal, 0):
#                 session_max_counts[animal] = count
#                 changed = True
                
#         if changed:
#             update_db(session_id, source_type, pole_id, session_max_counts)
        
#         ret, buffer = cv2.imencode('.jpg', frame)
#         yield (b'--frame\r\n'
#                b'Content-Type: image/jpeg\r\n\r\n' + buffer.tobytes() + b'\r\n')
               
#     cap.release()

# @app.route('/')
# def index():
#     return render_template('index.html')

# @app.route('/api/logs')
# def get_logs():
#     with sqlite3.connect('detections.db') as conn:
#         c = conn.cursor()
#         c.execute("SELECT timestamp, source, pole_id, summary FROM detections ORDER BY timestamp DESC LIMIT 50")
#         rows = c.fetchall()
        
#     logs = [{"timestamp": r[0], "source": r[1], "pole_id": r[2], "summary": r[3]} for r in rows]
#     return jsonify(logs)

# @app.route('/process_image', methods=['POST'])
# def process_image():
#     if 'image' not in request.files:
#         return jsonify({"error": "No image uploaded"}), 400
        
#     file = request.files['image']
#     conf = float(request.form.get('confidence', 0.5))
#     session_id = request.form.get('session_id', f"img_{datetime.now().timestamp()}")
#     pole_id = request.form.get('pole_id', 'Unknown') # Capture from JS FormData
    
#     filestr = file.read()
#     npimg = np.frombuffer(filestr, np.uint8)
#     frame = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

#     if frame is None:
#         return jsonify({"error": "Invalid image"}), 400

#     processed_frame, frame_counts = process_frame(frame, conf_threshold=conf)
    
#     update_db(session_id, "Image Upload", pole_id, frame_counts)
    
#     _, buffer = cv2.imencode('.jpg', processed_frame)
#     img_base64 = base64.b64encode(buffer).decode('utf-8')

#     return jsonify({"image": img_base64})


# @app.route('/webcam_feed')
# def webcam_feed():
#     session_id = request.args.get('session_id')
#     pole_id = request.args.get('pole', 'Unknown') # Capture from JS URL string
#     return Response(generate_frames(0, session_id, "Live Webcam", pole_id), mimetype='multipart/x-mixed-replace; boundary=frame')
# @app.route('/video_feed/<filename>')
# def video_feed(filename):
#     session_id = request.args.get('session_id')
#     pole_id = request.args.get('pole', 'Unknown') # Capture from JS URL string
#     filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
#     return Response(generate_frames(filepath, session_id, "Video Upload", pole_id), mimetype='multipart/x-mixed-replace; boundary=frame')
# @app.route('/upload_video', methods=['POST'])
# def upload_video():
#     if 'video' not in request.files:
#         return jsonify({"error": "No video uploaded"}), 400
        
#     file = request.files['video']
#     filename = secure_filename(file.filename)
#     filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
#     file.save(filepath)
    
#     return jsonify({"filename": filename})

# if __name__ == '__main__':
#     app.run(debug=True, port=5000)



import os
import cv2
import base64
import numpy as np
import sqlite3
import time
import logging
from datetime import datetime
from flask import Flask, render_template, request, Response, jsonify
from werkzeug.utils import secure_filename
from ultralytics import YOLO

# IMPORT MODEL 2
from model2_decision_engine import DecisionEngine

# --- MUTE MODEL 2 TERMINAL SPAM ---
# This stops Model 2 from printing "on alert cooldown" 30 times a second.
# It will now only print WARNINGs and ERRORs to the terminal.
logging.getLogger("Model2DecisionEngine").setLevel(logging.WARNING)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Initialize Model 2 Decision Engine
decision_engine = DecisionEngine()
decision_engine.cooldown_seconds = 5  # Override default 30s so we can escalate every 5 seconds

# Tracks escalation state: (pole_id, class_name) -> {"level": 1, "last_seen": timestamp}
escalation_tracker = {}

# Memory cache to prevent the same terminal message from printing every frame
last_terminal_print = {}

def init_db():
    with sqlite3.connect('detections.db') as conn:
        c = conn.cursor()
        c.execute('''CREATE TABLE IF NOT EXISTS detections
                     (session_id TEXT PRIMARY KEY, 
                      source TEXT,
                      pole_id TEXT,
                      summary TEXT, 
                      timestamp TEXT)''')
        conn.commit()

init_db()

model = YOLO("yolov8n.pt")
RELEVANT_CLASSES = {"person", "dog", "cat", "cow", "horse", "sheep", "bird", "elephant", "bear"}

def update_db(session_id, source_type, pole_id, counts_dict):
    if not counts_dict:
        summary = "None detected"
    else:
        summary = ", ".join([f"{count}x {animal}" for animal, count in counts_dict.items()])

    timestamp = datetime.now().isoformat(timespec="seconds")

    with sqlite3.connect('detections.db', timeout=10) as conn:
        c = conn.cursor()
        c.execute("SELECT session_id FROM detections WHERE session_id = ?", (session_id,))
        if c.fetchone():
            c.execute("UPDATE detections SET summary = ?, timestamp = ?, pole_id = ? WHERE session_id = ?",
                      (summary, timestamp, pole_id, session_id))
        else:
            c.execute("INSERT INTO detections (session_id, source, pole_id, summary, timestamp) VALUES (?, ?, ?, ?, ?)",
                      (session_id, source_type, pole_id, summary, timestamp))
        conn.commit()
        
        
def process_frame(frame, pole_id="Unknown", conf_threshold=0.5):
    """Runs YOLO, draws boxes, passes to Model 2, and returns frame + counts."""
    results = model.predict(frame, conf=conf_threshold, verbose=False)
    frame_counts = {}
    
    for result in results:
        for box in result.boxes:
            class_id = int(box.cls[0])
            class_name = model.names[class_id]

            if class_name not in RELEVANT_CLASSES:
                continue

            confidence = float(box.conf[0])
            x1, y1, x2, y2 = map(int, box.xyxy[0])

            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
            label = f"{class_name} {confidence:.2f}"
            cv2.putText(frame, label, (x1, max(y1 - 10, 0)),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

            frame_counts[class_name] = frame_counts.get(class_name, 0) + 1

            # --- MODEL 1 TO MODEL 2 HANDOFF ---
            detection_entry = {
                "type": class_name,
                "confidence": confidence,
                "timestamp": datetime.now().isoformat(timespec="seconds")
            }
            
            action = decision_engine.process_detection(detection_entry)
            
            # --- TERMINAL SPAM FILTER ---
            # Only print if it's a real hardware action, OR if it's the first time 
            # we've seen this animal in the last 30 seconds.
            # --- TERMINAL SPAM FILTER & SIMULATOR TRIGGER ---
            current_time = time.time()
            
            # Only trigger simulator if it's a real alert AND we haven't fired for this animal in 30s
            # if action in ["level_1_alert", "level_2_alert", "level_3_alert"] and (current_time - last_terminal_print.get(class_name, 0) > 30):
            #     print(f"🚨 [ACTION ENGINE] Pole {pole_id} | Detected: {class_name.upper()} | Decided Action: {action.upper()}")
            #     last_terminal_print[class_name] = current_time

            #     # Map Model 2 actions to Simulator device codes
            #     device_map = {"level_1_alert": "ll", "level_2_alert": "sp", "level_3_alert": "ws"}
            #     device_code = device_map[action]

            #     # Send HTTP POST to the Simulator running on port 5001
            #     try:
            #         import urllib.request
            #         import json
                    
            #         # Convert Pole 1-8 to internal 0-7 format for the simulator frontend
            #         sim_pole = str(int(pole_id) - 1) if str(pole_id).isdigit() else ""
                    
            #         url = "http://127.0.0.1:5001/api/trigger"
            #         payload = json.dumps({"device": device_code, "pole": sim_pole}).encode('utf-8')
            #         headers = {'Content-Type': 'application/json'}
                    
            #         req = urllib.request.Request(url, data=payload, headers=headers)
            #         urllib.request.urlopen(req, timeout=1.0) # 1 sec timeout so YOLO doesn't freeze
            #         print(f"📡 [SIMULATOR] Successfully triggered '{device_code}' on pole {pole_id}")
            #     except Exception as e:
            #         print(f"⚠️ [SIMULATOR API FAILED] Is simulator app.py running on port 5001?: {e}")
            # --- STATEFUL ESCALATION & SIMULATOR TRIGGER ---
            current_time = time.time()
            
            # If Model 2 authorizes an alert (happens every 5s if animal stays in view)
            if action in ["level_1_alert", "level_2_alert", "level_3_alert"]:
                
                state_key = (str(pole_id), class_name)
                state = escalation_tracker.get(state_key, {"level": 0, "last_seen": 0})
                
                # If animal was gone for > 60 seconds, reset to Level 1.
                # Otherwise, escalate to the next level (max Level 3).
                if current_time - state["last_seen"] > 60:
                    state["level"] = 1
                else:
                    state["level"] = min(state["level"] + 1, 3)
                
                state["last_seen"] = current_time
                escalation_tracker[state_key] = state
                
                # Override action string based on our escalation tracker
                actual_action = f"level_{state['level']}_alert"
                
                print(f"🚨 [ESCALATION ENGINE] Pole {pole_id} | {class_name.upper()} | Triggering: {actual_action.upper()}")

                # Map actions to Simulator device codes
                device_map = {"level_1_alert": "ll", "level_2_alert": "sp", "level_3_alert": "ws"}
                device_code = device_map[actual_action]

                # Send HTTP POST to the Simulator (port 5001)
                try:
                    import urllib.request
                    import json
                    
                    sim_pole = str(int(pole_id) - 1) if str(pole_id).isdigit() else ""
                    
                    url = "http://127.0.0.1:5001/api/trigger"
                    payload = json.dumps({"device": device_code, "pole": sim_pole}).encode('utf-8')
                    headers = {'Content-Type': 'application/json'}
                    
                    req = urllib.request.Request(url, data=payload, headers=headers)
                    urllib.request.urlopen(req, timeout=1.0)
                    print(f"   📡 [SIMULATOR] Successfully activated '{device_code}' on pole {pole_id}")
                except Exception as e:
                    print(f"   ⚠️ [SIMULATOR API FAILED] Is simulator running on port 5001?: {e}")
                    
    return frame, frame_counts

def generate_frames(source, session_id, source_type, pole_id):
    cap = cv2.VideoCapture(source)
    session_max_counts = {}

    update_db(session_id, source_type, pole_id, session_max_counts)

    while True:
        success, frame = cap.read()
        if not success:
            break
        
        frame, frame_counts = process_frame(frame, pole_id=pole_id)
        
        changed = False
        for animal, count in frame_counts.items():
            if count > session_max_counts.get(animal, 0):
                session_max_counts[animal] = count
                changed = True
                
        if changed:
            update_db(session_id, source_type, pole_id, session_max_counts)
        
        ret, buffer = cv2.imencode('.jpg', frame)
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + buffer.tobytes() + b'\r\n')
               
    cap.release()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/logs')
def get_logs():
    with sqlite3.connect('detections.db') as conn:
        c = conn.cursor()
        c.execute("SELECT timestamp, source, pole_id, summary FROM detections ORDER BY timestamp DESC LIMIT 50")
        rows = c.fetchall()
        
    logs = [{"timestamp": r[0], "source": r[1], "pole_id": r[2], "summary": r[3]} for r in rows]
    return jsonify(logs)

@app.route('/process_image', methods=['POST'])
def process_image():
    if 'image' not in request.files:
        return jsonify({"error": "No image uploaded"}), 400
        
    file = request.files['image']
    conf = float(request.form.get('confidence', 0.5))
    session_id = request.form.get('session_id', f"img_{datetime.now().timestamp()}")
    pole_id = request.form.get('pole_id', 'Unknown')
    
    filestr = file.read()
    npimg = np.frombuffer(filestr, np.uint8)
    frame = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

    if frame is None:
        return jsonify({"error": "Invalid image"}), 400

    processed_frame, frame_counts = process_frame(frame, pole_id=pole_id, conf_threshold=conf)
    
    update_db(session_id, "Image Upload", pole_id, frame_counts)
    
    _, buffer = cv2.imencode('.jpg', processed_frame)
    img_base64 = base64.b64encode(buffer).decode('utf-8')

    return jsonify({"image": img_base64})

@app.route('/webcam_feed')
def webcam_feed():
    session_id = request.args.get('session_id')
    pole_id = request.args.get('pole', 'Unknown')
    return Response(generate_frames(0, session_id, "Live Webcam", pole_id), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/video_feed/<filename>')
def video_feed(filename):
    session_id = request.args.get('session_id')
    pole_id = request.args.get('pole', 'Unknown')
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    return Response(generate_frames(filepath, session_id, "Video Upload", pole_id), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/upload_video', methods=['POST'])
def upload_video():
    if 'video' not in request.files:
        return jsonify({"error": "No video uploaded"}), 400
        
    file = request.files['video']
    filename = secure_filename(file.filename)
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(filepath)
    
    return jsonify({"filename": filename})

if __name__ == '__main__':
    app.run(debug=True, port=5000)