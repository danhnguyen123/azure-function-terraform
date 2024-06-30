import logging
import os

from azure.identity import DefaultAzureCredential

from azure.storage.blob import BlobServiceClient

from azure.storage.filedatalake import (
    DataLakeServiceClient,
    FileSystemClient,
    DataLakeDirectoryClient,
)

# Acquire a credential object
credential = DefaultAzureCredential()


class StorageDatalake:
    def __init__(self) -> None:
        account_url = f"https://{os.getenv('STORAGE_DATALAKE')}.dfs.core.windows.net"

        self.datalake_service_client = DataLakeServiceClient(account_url, credential=credential)
        self.file_system_client = self._get_file_system_client(container_name=os.getenv('DATALAKE_CONTAINER_NAME'))
        self.directory_client = self._get_directory_client(directory_name=os.getenv('DATALAKE_DIRECTORY_NAME'))

    def _get_file_system_client(self, container_name) -> FileSystemClient:
        client = self.datalake_service_client.get_file_system_client(file_system=container_name)
        return client
    
    def _get_directory_client(self, directory_name) -> DataLakeDirectoryClient:
        client = self.file_system_client.get_directory_client(directory=directory_name)
        return client

    def download_file(self, file_name: str):

        file_client = self.directory_client.get_file_client(file_name)
        download = file_client.download_file()
        content = download.readall()
        return content

class StorageBlob:
    def __init__(self) -> None:
        account_url = f"https://{os.getenv('STORAGE_BLOB')}.blob.core.windows.net"
        self.blob_service_client  = BlobServiceClient(account_url=account_url, credential=credential)
    

    def download_file(self, container_name=os.getenv('BLOB_CONTAINER_NAME'), blob=None):

        blob_client =  self.blob_service_client.get_blob_client(container=container_name, blob=blob)
        download_stream = blob_client.download_blob()
        content = download_stream.readall()
        return content
