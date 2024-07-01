# import os
# from azure.eventgrid import EventGridPublisherClient
# from azure.core.credentials import AzureKeyCredential

# topic_key = os.environ["EVENTGRID_TOPIC_KEY"]
# endpoint = os.environ["EVENTGRID_TOPIC_ENDPOINT"]

# credential_key = AzureKeyCredential(topic_key)
# client = EventGridPublisherClient(endpoint, credential_key)