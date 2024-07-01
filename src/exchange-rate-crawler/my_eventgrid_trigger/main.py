import json
import logging

from azure.functions import EventGridEvent
import threading

def main(event: EventGridEvent, context):
    logging.info(f'[{context.invocation_id}] Python EventGrid trigger function processed a request.')
    result = json.dumps({
        'id': event.id,
        'data': event.get_json(),
        'topic': event.topic,
        'subject': event.subject,
        'event_type': event.event_type,
    })

    logging.info('Python EventGrid trigger processed an event: %s', result)

# def log_function(context):
#     context.thread_local_storage.invocation_id = context.invocation_id
#     logging.info('Logging from thread.')