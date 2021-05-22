#!/usr/local/bin/python3

import json
import os
import requests
import sys

_url = ""
_alloc_id = ""

def build_url(alloc_id):
    # Check for NOMAD_ADDR, if found set the base of the URL to it.
    if os.environ.get('NOMAD_ADDR'):
        nomad_addr = os.environ.get('NOMAD_ADDR')

        # ... well, unless it's HTTPS.
        if nomad_addr.startswith("https"):
            raise ValueError("HTTPS is not implemented")

        url_base = os.environ.get('NOMAD_ADDR')
    else:
        url_base = "http://127.0.0.1:4646"



    URL_API_PATH = "/v1/event/stream"
    #URL_QUERY_STRING = ""
    URL_QUERY_STRING = "?topic=Allocation:"+alloc_id

    _url = url_base + URL_API_PATH + URL_QUERY_STRING
    return _url

def eprint(string):
    sys.stderr.write(string)
    sys.stderr.flush()   

def is_final(event):
    if event["Payload"]["Allocation"]["ClientStatus"] == "complete":
        eprint("Allocation complete\n")
        sys.exit(0)

    if event["Payload"]["Allocation"]["ClientStatus"] == "failed":
        eprint("Allocation failed\n")
        sys.exit(1)

def print_tasks(event):
    tasks = event["Payload"]["Allocation"]["TaskStates"]
    # print(json.dumps(tasks, sort_keys=True, indent=2))
    if tasks:
        for task_name, task in tasks.items():
            print("--- "+task_name+"\t"+task["State"]+"\t"+str(task["Failed"]))


def handle_event(event):
    # print(json.dumps(event["Payload"], sort_keys=True, indent=2))
    # print(json.dumps(event["Allocation"], sort_keys=True, indent=2))

    allocation = event["Payload"]["Allocation"]
    print(str(event["Index"])+"\t"+ event["Type"]+"\t"+allocation["DesiredStatus"]+"\t"+ allocation["ClientStatus"])

    # print_tasks(event)

    is_final(event)

def handle_data(response):
    '''
    Handle a single line of data from the HTTP stream.
    '''
    for line in response.iter_lines():
        if line:   # filter out keep-alive new lines
            object = json.loads(line.decode('utf-8'))
            if len(object) > 1:  # has Events
                for event in object["Events"]:
                    handle_event(event)

def connect(url):
    try:
        eprint("Connecting to '"+url+"'\n")
        response = requests.get(url, stream=True)
        response.raise_for_status()
        handle_data(response)
    except requests.exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

def start():
    try:
        
        connect(build_url(check_args()))
    except KeyboardInterrupt:
        eprint("Received keyboard interrupt. Stopping.\n")
        SystemExit()

def check_args():
    # look for 2 items, because argv[0] is always the script's name. :\
    if len(sys.argv) != 2:
        raise ValueError("Must supply a full Nomad alloc id.")
    alloc_id = sys.argv[1]
    return alloc_id
start()