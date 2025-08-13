"""
Foundation validation test for ZIP download function app.
"""


def test_foundation_imports():
    """Test that all foundation components import correctly."""
    try:
        # Test constants
        from core.constants import AppConstants, AzureConstants, DownloadConstants

        print("✅ Constants imported successfully")
        print(f"   - Max files per ZIP: {DownloadConstants.MAX_FILES_PER_ZIP}")
        print(f"   - Max ZIP size (GB): {DownloadConstants.MAX_TOTAL_SIZE_GB}")
        print(f"   - SAS function URL: {AzureConstants.SAS_FUNCTION_URL}")

        # Test enums
        from core.enums import (
            ErrorType,
            ResponseStatus,
            DownloadStatus,
            DownloadErrorType,
            CompressionLevel,
            AccessType,
        )

        print("✅ Enums imported successfully")
        print(f"   - Download statuses: {len(list(DownloadStatus))} defined")
        print(f"   - Error types: {len(list(ErrorType))} defined")
        print(f"   - Compression levels: {[level.value for level in CompressionLevel]}")

        # Test module structure
        import core.helpers
        import core.services

        print("✅ Module structure validated")

        print("✅ Foundation setup completed successfully!")
        return True

    except ImportError as e:
        print(f"❌ Import error: {e}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False


if __name__ == "__main__":
    success = test_foundation_imports()
    exit(0 if success else 1)
