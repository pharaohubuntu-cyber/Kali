#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# 1. System update
sudo apt-get update

# 2. Install Xfce Desktop, VNC server, and noVNC web proxy
sudo apt-get install -y kali-desktop-xfce x11vnc xvfb novnc dbus-x11

# 3. Create a script to launch the virtual display and web stream
cat << 'EOF' > ~/start-desktop.sh
#!/bin/bash
# Clear old locks
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# Start virtual frame buffer (Display :1)
Xvfb :1 -screen 0 1280x720x24 &
sleep 2

# Start Xfce session tied to virtual display
DISPLAY=:1 startxfce4 &
sleep 2

# Share the virtual display over VNC (no password required for simple cloud testing)
x11vnc -display :1 -nopw -listen localhost -forever -shared &
sleep 2

# Launch noVNC to translate VNC into a web page on port 6080
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 6080
EOF

chmod +x ~/start-desktop.sh
echo "GUI components installed. Run ~/start-desktop.sh to boot the desktop."
