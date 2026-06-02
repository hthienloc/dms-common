#!/usr/bin/env python3
import os
import shutil
import subprocess
import sys

def main():
    # Central dms-common directory (the directory containing this script)
    src_dir = os.path.dirname(os.path.abspath(__file__))
    parent_dir = os.path.dirname(src_dir)
    
    print("Starting synchronization of dms-common components...")
    print(f"Source: {src_dir}")
    print(f"Parent directory: {parent_dir}\n")

    # List of files/directories to ignore during sync
    ignore_list = {".git", "sync.py", "sync.sh", "__pycache__"}

    # Find all sibling directories starting with dms-*
    synced_count = 0
    failed_count = 0
    
    for item in os.listdir(parent_dir):
        if not item.startswith("dms-") or item == "dms-common":
            continue
            
        plugin_dir = os.path.join(parent_dir, item)
        if not os.path.isdir(plugin_dir):
            continue
            
        dest_dir = os.path.join(plugin_dir, "dms-common")
        if not os.path.exists(dest_dir) or not os.path.isdir(dest_dir):
            continue
            
        print(f"--- Syncing: {item} ---")
        
        # 1. Clear existing files in destination dms-common (except git/submodule tracking if present)
        try:
            for file_name in os.listdir(dest_dir):
                if file_name == ".git":
                    continue
                file_path = os.path.join(dest_dir, file_name)
                if os.path.isdir(file_path):
                    shutil.rmtree(file_path)
                else:
                    os.remove(file_path)
        except Exception as e:
            print(f"  Error clearing destination: {e}")
            failed_count += 1
            continue

        # 2. Copy all files from source
        try:
            for file_name in os.listdir(src_dir):
                if file_name in ignore_list:
                    continue
                src_path = os.path.join(src_dir, file_name)
                dest_path = os.path.join(dest_dir, file_name)
                if os.path.isdir(src_path):
                    shutil.copytree(src_path, dest_path)
                else:
                    shutil.copy2(src_path, dest_path)
            print(f"  Copied files to {dest_dir}")
        except Exception as e:
            print(f"  Error copying files: {e}")
            failed_count += 1
            continue

        # 3. Run qmllint on the destination files
        try:
            qml_files = [os.path.join(dest_dir, f) for f in os.listdir(dest_dir) if f.endswith('.qml')]
            if qml_files:
                subprocess.run(["qmllint"] + qml_files, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                print("  qmllint check: PASSED")
            else:
                print("  No QML files to lint")
        except subprocess.CalledProcessError:
            print("  qmllint check: FAILED")
            failed_count += 1
            continue
        except FileNotFoundError:
            print("  qmllint check: SKIPPED (qmllint not found)")

        # 4. Git commit local (if dirty)
        try:
            if os.path.exists(os.path.join(plugin_dir, ".git")):
                status = subprocess.run(["git", "-C", plugin_dir, "status", "--porcelain"], capture_output=True, text=True, check=True)
                if status.stdout.strip():
                    subprocess.run(["git", "-C", plugin_dir, "add", "dms-common/"], check=True)
                    subprocess.run(["git", "-C", plugin_dir, "commit", "-m", "feat(common): sync dms-common components to latest version"], check=True)
                    print("  Local commit: CREATED")
                else:
                    print("  No changes to commit (working tree clean)")
        except subprocess.CalledProcessError as e:
            print(f"  Git commit failed: {e} (might be due to merge conflict in other files)")
            
        synced_count += 1

    print(f"\nDone! Successfully synchronized {synced_count} plugins ({failed_count} failures/warnings).")

if __name__ == "__main__":
    main()
