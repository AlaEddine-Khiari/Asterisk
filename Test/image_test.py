import subprocess
import os

def check_asterisk_version(expected_version):
    try:
        version_output = subprocess.check_output(['asterisk', '-rx', 'core show version']).decode('utf-8')
        if expected_version not in version_output:
            raise Exception(f"Asterisk version is not {expected_version}")
    except subprocess.CalledProcessError as e:
        raise Exception(f"Error executing command: {e}")

def check_sip_module_loaded():
    try:
        modules_output = subprocess.check_output(['asterisk', '-rx', 'module show like chan_sip.so']).decode('utf-8')
        if 'chan_sip.so' not in modules_output:
            raise Exception("SIP module is not loaded")
    except subprocess.CalledProcessError as e:
        raise Exception(f"Error executing command: {e}")

if __name__ == "__main__":
    try:
        # Check if the Asterisk control file exists
        if not os.path.exists('/var/run/asterisk/asterisk.ctl'):
            raise Exception("Asterisk control file '/var/run/asterisk/asterisk.ctl' does not exist")

        check_asterisk_version('18.21')
        check_sip_module_loaded()
        print("Tests passed: Asterisk version is 18.21 and SIP module is loaded.")
    except Exception as e:
        print(f"Tests failed: {str(e)}")
        exit(1)
