#!/bin/bash
pip install requirements.txt
export FLASK_APP=app.py

# Start Flask instances on different ports
python -m flask run --host=0.0.0.0 --port=5002 &
python -m flask run --host=0.0.0.0 --port=5003 &
python -m flask run --host=0.0.0.0 --port=5004 &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
