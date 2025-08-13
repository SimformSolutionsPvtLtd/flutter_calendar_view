"""
Application-level constants and configuration values.
"""

import os
from typing import Final


class AppConstants:
    """
    Container class for application-level constants and configuration.

    This class provides centralized access to HTTP status codes, general
    application settings, and framework-level configuration.
    """

    # HTTP Status Codes
    HTTP_OK: Final[int] = 200
    HTTP_BAD_REQUEST: Final[int] = 400
    HTTP_UNAUTHORIZED: Final[int] = 401
    HTTP_FORBIDDEN: Final[int] = 403
    HTTP_NOT_FOUND: Final[int] = 404
    HTTP_CONFLICT: Final[int] = 409
    HTTP_INTERNAL_SERVER_ERROR: Final[int] = 500
    HTTP_SERVICE_UNAVAILABLE: Final[int] = 503

    # Content Types
    CONTENT_TYPE_JSON: Final[str] = "application/json"
    CONTENT_TYPE_TEXT: Final[str] = "text/plain"
    CONTENT_TYPE_ZIP: Final[str] = "application/zip"

    # General Configuration
    DEFAULT_TIMEOUT_SECONDS: Final[int] = 30
    MAX_RETRY_ATTEMPTS: Final[int] = 3
    RETRY_BACKOFF_FACTOR: Final[float] = 1.5

    # Environment Variables
    ENVIRONMENT: Final[str] = os.getenv("ENVIRONMENT", "development")
    LOG_LEVEL: Final[str] = os.getenv("LOG_LEVEL", "INFO")

    # Request Processing
    MAX_REQUEST_SIZE_MB: Final[int] = 32  # Azure Function default
    REQUEST_TIMEOUT_SECONDS: Final[int] = 300  # 5 minutes
