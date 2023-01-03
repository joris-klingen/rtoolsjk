import requests
import zipfile
import pathlib
import shutil

DEST_FOLDER = "C:/python_projects/_uitproberen/test_project/src/"


def download(url: str, dest_path):
    r = requests.get(url, stream=True)
    if not r.ok:
        raise ValueError("Download failed: check repo and language")

    with open(dest_path, "wb") as f:
        for chunk in r.iter_content():
            if chunk:
                f.write(chunk)


def unzip(zip_store, dest_folder):
    with zipfile.ZipFile(zip_store) as zipfile_:
        for filename in zipfile_.namelist():
            zipfile_.extract(filename, path=dest_folder)


def move(dest_folder, ori_folder) -> None:
    # p_ori = dest_folder / "tools-onderzoek-en-statistiek-main" / language
    # p_dest = dest_folder / "os_tools"
    # p_del = dest_folder / "tools-onderzoek-en-statistiek-main"

    print(f"{dest_folder=}")
    print(f"{ori_folder=}")

    if dest_folder.exists():
        shutil.rmtree(dest_folder)

    shutil.move(ori_folder, dest_folder)
    # shutil.rmtree(p_del)


class FileLocation:
    git_url = "https://gitlab.com/os-amsterdam/"
    language = "python"

    def __init__(self, dest_folder, repo, branch, language):
        self.dest_folder = pathlib.Path(dest_folder)
        self.repo = repo
        self.branch = branch
        self.language = language

    @property
    def url(self):
        return f"https://gitlab.com/os-amsterdam/{self.repo}/-/archive/main/{self.repo}-{self.branch}.zip"

    @property
    def zipfile(self):
        return self.dest_folder / "_temp.zip"

    @property
    def move_folder(self):
        return self.dest_folder / self.repo / self.language

    @property
    def unzipped_folder(self):
        return self.dest_folder / self.repo

    @property
    def os_tools_folder(self):
        return self.dest_folder / "os_tools"


def copy_os_tools(dest_folder: str, branch="main", language="python"):
    REPO = "tools-onderzoek-en-statistiek"
    fl = FileLocation(
        dest_folder=dest_folder, repo=REPO, branch=branch, language=language
    )

    download(fl.url, dest_path=fl.zipfile)
    unzip(fl.zipfile, fl.dest_folder)
    move(fl.move_folder, fl.os_tools_folder)

    # zip_store.unlink()

    # if fl.os_tools_folder.exists():
    #     shutil.rmtree(fl.os_tools_folder)

    # shutil.move(fl. , p_dest)
    # shutil.rmtree(p_del)


if __name__ == "__main__":
    copy_os_tools(DEST_FOLDER)
