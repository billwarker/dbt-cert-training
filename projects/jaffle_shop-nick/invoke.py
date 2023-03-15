import os
import subprocess
import http.server
import socketserver

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello, World!")
        cmd = subprocess.Popen(["/bin/sh", "script.sh"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = cmd.communicate()
        if cmd.returncode != 0:
            print(f"script.sh failed with error: {stderr.decode()}")
        else:
            print(f"script.sh output: {stdout.decode()}")

PORT = int(os.environ.get("PORT", 8080))
print(f"Starting server on port {PORT}")
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass

print("Shutting down server")
httpd.server_close()
