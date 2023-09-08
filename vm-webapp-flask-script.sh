sudo apt update
sudo apt install -y python3 python3-pip
sudo apt install libpq-dev -y
sudo apt install python3-flask

pip3 install fastapi
pip3 install uvicorn
pip3 install psycopg2
pip3 install Flask
pip3 install Flask-SQLAlchemy

Flask Flask-SQLAlchemy psycopg2
apt-get install -y python3-flask python3-itsdangerous python3-pyinotify python3-simplejson python3-werkzeug
git clone https://github.com/tal098123/baruchi_project.git
# Run the Flask app
# current_dir="$( cd "$(dirname "$0")" ; pwd -P )"
# Get the latest script directory
latest_dir=$(ls -v /var/lib/waagent/custom-script/download/ | tail -n 1)

python3 /var/lib/waagent/custom-script/download/$latest_dir/baruchi_project/flask_app/app.py &
# python3 /var/lib/waagent/custom-script/download/0/baruchi_project/flask_app/app.py &

# python3 /home/tal/baruchi_project/flask_app/app.py



