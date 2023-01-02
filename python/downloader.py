import requests
import zipfile
from pathlib import Path
import shutil

DEST_FOLDER = "C:/python_projects/_uitproberen/test_project/src/"
URL = "https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/archive/main/tools-onderzoek-en-statistiek-main.zip?path=python"


def download(url: str, dest_path):

    r = requests.get(url, stream=True)
    if not r.ok:
        print("Download failed")

    with open(dest_path, "wb") as f:
        for chunk in r.iter_content():
            if chunk:
                f.write(chunk)


def unzip(zip_store, dest_folder):
    with zipfile.ZipFile(zip_store) as zipfile_:
        for filename in zipfile_.namelist():
            zipfile_.extract(filename, path=dest_folder)


def move(dest_folder):
    p_ori = dest_folder / "tools-onderzoek-en-statistiek-main-python/python"
    p_dest = dest_folder / "os_tools"
    p_del = dest_folder / "tools-onderzoek-en-statistiek-main-python"

    if p_dest.exists():
        shutil.rmtree(p_dest)

    shutil.move(p_ori, p_dest)
    shutil.rmtree(p_del)


def copy_os_tools(url: str, dest_folder: str):
    p = Path(dest_folder)
    zip_store = p / "os_python.zip"
    print(zip_store)

    download(URL, dest_path=zip_store)
    unzip(zip_store, p)
    move(p)

    zip_store.unlink()


if __name__ == "__main__":
    copy_os_tools(URL, DEST_FOLDER)
