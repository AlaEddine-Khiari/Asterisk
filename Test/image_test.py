import subprocess

def check_asterisk_version(expected_version):
    version_output = subprocess.check_output(['asterisk', '-rx', 'core show version']).decode('utf-8')
    if expected_version not in version_output:
        raise Exception(f"Asterisk version is not {expected_version}")

def check_sip_module_loaded():
    modules_output = subprocess.check_output(['asterisk', '-rx', 'module show like chan_sip.so']).decode('utf-8')
    if 'chan_sip.so' not in modules_output:
        raise Exception("SIP module is not loaded")

if __name__ == "__main__":
    try:
        check_asterisk_version('18.21')
        check_sip_module_loaded()
        print("Tests passed: Asterisk version is 18.21 and SIP module is loaded.")
    except Exception as e:
        print(f"Tests failed: {str(e)}")
        exit(1)
