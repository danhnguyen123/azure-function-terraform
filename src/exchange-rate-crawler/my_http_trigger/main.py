import logging
import os
import azure.functions as func

from helper.storage_helper import StorageDatalake, StorageBlob

storage_datalake_client = StorageDatalake()
storage_blob_client = StorageBlob()

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    logging.info(f"ENV: {os.getenv('ENVIRONMENT')}")
    logging.info(f"PRODUCT_NAME: {os.getenv('PRODUCT_NAME')}")

    try:
        datalake_file_content = storage_datalake_client.download_file(file_name="test.csv")
        logging.info(f"datalake_file_content: {datalake_file_content}")

        blob_file_content = storage_blob_client.download_file(blob="blob_files/test.csv")
        logging.info(f"blob_file_content: {blob_file_content}")
    except Exception as e:
        logging.error(e)
        raise(e)

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')


    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )
