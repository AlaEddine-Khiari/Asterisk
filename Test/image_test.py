import docker

def verify_sip_module(image_name):
    # Connect to Docker daemon
    client = docker.from_env()

    try:
        # Run the Docker container
        container = client.containers.run(image_name, detach=True, tty=True)

        # Execute Asterisk CLI command to check if SIP module is loaded
        exec_command = "asterisk -rx 'module show like chan_sip.so'"
        exec_result = container.exec_run(exec_command)

        # Print command output
        print("Command Output:")
        print(exec_result.output.decode())

        # Check if SIP module is loaded
        if "chan_sip.so" in exec_result.output.decode():
            print("SIP module is loaded!")
        else:
            print("SIP module is not loaded!")

    finally:
        # Delete the container
        if container:
            container.remove(force=True)
            print("Container deleted successfully.")

if __name__ == "__main__":
    # Replace "your-asterisk-image" with the name of your Asterisk Docker image
    verify_sip_module("asterisk-image")
