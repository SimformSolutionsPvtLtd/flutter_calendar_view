"""
Enumeration classes for ZIP download functionality status tracking.
"""

from enum import Enum
from typing import Final


class DownloadStatus(Enum):
    """
    Status values for ZIP download operations.

    These values track the lifecycle of a ZIP download request
    from initiation through completion or failure.
    """

    PENDING = "pending"
    VALIDATING = "validating"
    PROCESSING = "processing"
    DOWNLOADING = "downloading"
    COMPRESSING = "compressing"
    UPLOADING = "uploading"
    COMPLETED = "completed"
    FAILED = "failed"
    EXPIRED = "expired"
    CANCELLED = "cancelled"


class DownloadErrorType(Enum):
    """
    Categories of errors that can occur during ZIP download operations.

    These provide structured error classification for better
    error handling and user feedback.
    """

    VALIDATION_ERROR = "validation_error"
    FILE_NOT_FOUND = "file_not_found"
    SIZE_LIMIT_EXCEEDED = "size_limit_exceeded"
    COUNT_LIMIT_EXCEEDED = "count_limit_exceeded"
    TIMEOUT_ERROR = "timeout_error"
    MEMORY_ERROR = "memory_error"
    STORAGE_ERROR = "storage_error"
    COMPRESSION_ERROR = "compression_error"
    NETWORK_ERROR = "network_error"
    PERMISSION_ERROR = "permission_error"
    SAS_SERVICE_ERROR = "sas_service_error"
    UNKNOWN_ERROR = "unknown_error"


class CompressionLevel(Enum):
    """
    ZIP compression level options.

    These values correspond to standard ZIP compression levels
    with performance vs. size trade-offs.
    """

    NO_COMPRESSION = 0
    FASTEST = 1
    FAST = 3
    DEFAULT = 6
    MAXIMUM = 9


class DownloadRequestType(Enum):
    """
    Types of download requests supported by the system.

    Currently supports ZIP archives with room for future expansion.
    """

    ZIP_ARCHIVE = "zip_archive"
    STREAMING_ZIP = "streaming_zip"  # For future large ZIP handling


class AccessType(Enum):
    """
    Access type enumeration for SAS token requests.
    """

    READ = "READ"
    WRITE = "WRITE"
    READ_WRITE = "READ_WRITE"


# Constants for status checking and timeouts
class StatusConstants:
    """
    Constants related to status checking and lifecycle management.
    """

    # Status check intervals (in seconds)
    STATUS_CHECK_INTERVAL: Final[int] = 5
    MAX_STATUS_CHECKS: Final[int] = 120  # 10 minutes max

    # Status transitions allowed
    VALID_STATUS_TRANSITIONS: Final[dict] = {
        DownloadStatus.PENDING: [
            DownloadStatus.VALIDATING,
            DownloadStatus.FAILED,
            DownloadStatus.CANCELLED,
        ],
        DownloadStatus.VALIDATING: [
            DownloadStatus.PROCESSING,
            DownloadStatus.FAILED,
            DownloadStatus.CANCELLED,
        ],
        DownloadStatus.PROCESSING: [
            DownloadStatus.DOWNLOADING,
            DownloadStatus.FAILED,
            DownloadStatus.CANCELLED,
        ],
        DownloadStatus.DOWNLOADING: [
            DownloadStatus.COMPRESSING,
            DownloadStatus.FAILED,
            DownloadStatus.CANCELLED,
        ],
        DownloadStatus.COMPRESSING: [
            DownloadStatus.UPLOADING,
            DownloadStatus.FAILED,
            DownloadStatus.CANCELLED,
        ],
        DownloadStatus.UPLOADING: [DownloadStatus.COMPLETED, DownloadStatus.FAILED],
        DownloadStatus.COMPLETED: [DownloadStatus.EXPIRED],
        DownloadStatus.FAILED: [],
        DownloadStatus.EXPIRED: [],
        DownloadStatus.CANCELLED: [],
    }
