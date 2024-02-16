#!/usr/bin/env python3

import sys
from asterisk.agi import AGI

# Get the destination number from the command line arguments
destination_number = sys.argv[1]

# Initialize AGI object
agi = AGI()

# Function to handle call forwarding
def forward_call(destination):
    agi.verbose("Forwarding call to {}".format(destination))
    agi.set_variable("FORWARD_DESTINATION", destination)
