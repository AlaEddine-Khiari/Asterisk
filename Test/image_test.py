import docker

def run_sip_module_test(image_name):
    # Connect to Docker daemon
    client = docker.from_env()

    try:
        # Run the Docker container
        container = client.containers.run(image_name, detach=True)

        # Execute SIP-related test commands within the container
        test_command = "asterisk -rx 'sip show peers'"
        exec_result = container.exec_run(test_command)

        # Print test command output
        print("SIP Module Test Output:")
        print(exec_result.output.decode())

        # Check if test output indicates success or failure
        if "Some Success Condition" in exec_result.output.decode():
            print("SIP module test passed!")
        else:
            print("SIP module test failed!")
            # Exit
            exit(1)

    finally:
        #Delete the container
        if container:
            container.remove(force=True)
            print("Container deleted successfully.")

if __name__ == "__main__":
    # Replace "your-asterisk-image" with the name of your Asterisk Docker image
    run_sip_module_test("asterisk-image")
