"""
Download-specific constants and configuration values for ZIP functionality.
"""

import os
from typing import Final


class DownloadConstants:
    """
    Container class for ZIP download-specific constants and configuration.

    This class provides centralized access to ZIP download limits, timeouts,
    and configuration specific to the ZIP download functionality.
    """

    # Core limits (conservative for 40-hour MVP implementation)
    MAX_FILES_PER_ZIP: Final[int] = int(os.getenv("MAX_ZIP_FILES", "25"))
    MAX_TOTAL_SIZE_GB: Final[int] = int(os.getenv("MAX_ZIP_SIZE_GB", "5"))
    MAX_INDIVIDUAL_FILE_SIZE_GB: Final[int] = 1  # Individual file limit

    # ZIP configuration
    ZIP_EXPIRY_MINUTES: Final[int] = int(os.getenv("ZIP_EXPIRY_MINUTES", "60"))
    DEFAULT_COMPRESSION_LEVEL: Final[int] = 6  # ZIP compression (0-9)
    TEMP_CONTAINER_NAME: Final[str] = os.getenv("TEMP_ZIP_CONTAINER", "temp-zips")

    # Processing timeouts (in seconds)
    BLOB_DOWNLOAD_TIMEOUT: Final[int] = 300  # 5 minutes per blob
    ZIP_CREATION_TIMEOUT: Final[int] = 600  # 10 minutes total
    MAX_PROCESSING_TIME: Final[int] = 480  # 8 minutes (under function limit)

    # Memory management
    MAX_MEMORY_USAGE_GB: Final[float] = 1.5  # Conservative memory limit
    CHUNK_SIZE_BYTES: Final[int] = 8192  # 8KB chunks for streaming

    # Validation limits
    MIN_FILES_PER_ZIP: Final[int] = 1
    MAX_ZIP_NAME_LENGTH: Final[int] = 100

    # Temporary file naming
    ZIP_FILE_PREFIX: Final[str] = "download_"
    ZIP_FILE_EXTENSION: Final[str] = ".zip"

    # Integration endpoints
    SAS_ENDPOINT_PATH: Final[str] = "/api/get-blob-sas-token"
    ZIP_ENDPOINT_PATH: Final[str] = "/api/download-zip"

    # HTTP Configuration
    HTTP_TIMEOUT_SECONDS: Final[int] = 30
    MAX_CONCURRENT_DOWNLOADS: Final[int] = 5
