"""
Azure service-specific constants and configuration.
"""

import os
from typing import Final


class AzureConstants:
    """
    Container class for Azure service configuration and constants.

    This class provides centralized access to Azure-specific settings,
    including storage account configuration, service endpoints, and
    Azure Function-specific parameters.
    """

    # Storage Configuration
    STORAGE_CONNECTION_STRING: Final[str] = os.getenv("AzureWebJobsStorage", "")
    STORAGE_ACCOUNT_URL: Final[str] = os.getenv("STORAGE_ACCOUNT_URL", "")

    # Container Names
    TEMP_CONTAINER_NAME: Final[str] = os.getenv("TEMP_ZIP_CONTAINER", "temp-zips")

    # SAS Token Configuration
    SAS_EXPIRY_MINUTES: Final[int] = int(os.getenv("SAS_EXPIRY_MINUTES", "60"))
    SAS_PERMISSIONS_READ: Final[str] = "r"
    SAS_PERMISSIONS_WRITE: Final[str] = "w"
    SAS_PERMISSIONS_READ_WRITE: Final[str] = "rw"

    # Integration with SAS Function App
    SAS_FUNCTION_URL: Final[str] = os.getenv("SAS_FUNCTION_URL", "")
    SAS_FUNCTION_KEY: Final[str] = os.getenv("SAS_FUNCTION_KEY", "")
    SAS_FUNCTION_TIMEOUT: Final[int] = int(os.getenv("SAS_FUNCTION_TIMEOUT", "30"))

    # Azure Function Configuration
    FUNCTION_TIMEOUT_MINUTES: Final[int] = int(
        os.getenv("FUNCTION_TIMEOUT_MINUTES", "10")
    )
    FUNCTION_MEMORY_LIMIT_MB: Final[int] = int(
        os.getenv("FUNCTION_MEMORY_LIMIT_MB", "1024")
    )

    # Blob Storage Settings
    BLOB_CHUNK_SIZE: Final[int] = 8192  # 8KB chunks
    MAX_BLOB_SIZE_GB: Final[int] = int(os.getenv("MAX_BLOB_SIZE_GB", "5"))

    # Retry Configuration
    AZURE_RETRY_ATTEMPTS: Final[int] = 3
    AZURE_RETRY_DELAY_SECONDS: Final[int] = 1
