# file based on https://github.com/PeterJFrancoIII/Antigravity-Model-Reset-Timer/blob/main/launcher.py
import webview
import subprocess
import socket
import sys
import time
import os
import multiprocessing
from voila.app import Voila, VoilaConfiguration

## pyinstaller launcher.py --add-data "b_txt_templates:b_txt_templates"

def wait_for_server(port=8866):
    while True:
        try:
            with socket.create_connection(("127.0.0.1", port), timeout=1):
                return
        except OSError:
            time.sleep(0.5)

def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    try:
        # PyInstaller creates a temp folder and stores path in _MEIPASS
        base_path = sys._MEIPASS # type: ignore
    except Exception:
        base_path = os.path.abspath(".")

    return os.path.join(base_path, relative_path)

def start_server():
    print("starting server")

    app = Voila()

    notebook = resource_path("index.ipynb")
    template_path = resource_path("b_txt_templates")

    # Inject into Jupyter search path
    os.environ["JUPYTER_PATH"] = template_path + os.pathsep + os.environ.get("JUPYTER_PATH", "")


    app.initialize([
        notebook,
        "--no-browser",
        "--port=8866",
        "--Voila.ip=127.0.0.1",
        "--Voila.preheat_kernel=True",
        "--Voila.default_pool_size=1",
        "--VoilaConfiguration.allow_template_override=NOTEBOOK",
        "--template=b-txt-app",
        f"--Voila.template_paths={template_path}"
    ])

    app.start()


def start_desktop_client():
    wait_for_server()
    window = webview.create_window(
        title='B-TXT Application',
        url="http://127.0.0.1:8866",
        height=768,
        width=1024
    )
    webview.start()


if __name__ == '__main__':
    server_process = multiprocessing.Process(target=start_server)
    # desktop_process = multiprocessing.Process(target=start_desktop_client)
    server_process.start()
    # desktop_process.start()
    # desktop_process.join()
    start_desktop_client()
    print("Desktop Client Closed, Stopping Server")
    server_process.terminate()
    server_process.join()
    print("Finished")