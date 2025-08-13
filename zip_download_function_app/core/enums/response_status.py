"""
HTTP response status enumeration for standardized API responses.
"""

from enum import Enum


class ResponseStatus(Enum):
    """
    Enumeration of response status types for consistent API responses.

    This enum provides standardized response status values that correspond
    to HTTP status codes and common API response patterns.
    """

    # Success Responses
    SUCCESS = "success"
    CREATED = "created"
    ACCEPTED = "accepted"
    NO_CONTENT = "no_content"

    # Client Error Responses
    BAD_REQUEST = "bad_request"
    UNAUTHORIZED = "unauthorized"
    FORBIDDEN = "forbidden"
    NOT_FOUND = "not_found"
    METHOD_NOT_ALLOWED = "method_not_allowed"
    CONFLICT = "conflict"
    PAYLOAD_TOO_LARGE = "payload_too_large"
    UNPROCESSABLE_ENTITY = "unprocessable_entity"
    TOO_MANY_REQUESTS = "too_many_requests"

    # Server Error Responses
    INTERNAL_SERVER_ERROR = "internal_server_error"
    NOT_IMPLEMENTED = "not_implemented"
    BAD_GATEWAY = "bad_gateway"
    SERVICE_UNAVAILABLE = "service_unavailable"
    GATEWAY_TIMEOUT = "gateway_timeout"

    # Custom Application Responses
    PROCESSING = "processing"
    VALIDATION_FAILED = "validation_failed"
    OPERATION_FAILED = "operation_failed"
    TIMEOUT = "timeout"
