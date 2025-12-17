#!/usr/bin/env python3
"""
Generate a presigned PUT URL for S3.

Usage:
    python generate-presigned.py filename
    python generate-presigned.py filename --bucket my-bucket
    python generate-presigned.py filename --bucket my-bucket --key custom/path/file.txt
"""

import sys
import argparse
import boto3
from botocore.exceptions import ClientError, NoCredentialsError
import os
from urllib.parse import quote

def generate_presigned_put_url(bucket, key, expiration=3600, region=None, content_type=None):
    """Generate a presigned URL for PUT operation on S3."""
    try:
        if region:
            s3_client = boto3.client('s3', region_name=region)
        else:
            s3_client = boto3.client('s3')
        
        # First, try to get the bucket location to verify it exists
        try:
            bucket_location = s3_client.get_bucket_location(Bucket=bucket)
            actual_region = bucket_location['LocationConstraint'] or 'us-east-1'
            
            # If user specified wrong region, warn them
            if region and region != actual_region:
                print(f"Warning: Bucket is in {actual_region}, not {region}. Using correct region.", file=sys.stderr)
                s3_client = boto3.client('s3', region_name=actual_region)
        except ClientError as e:
            if e.response['Error']['Code'] == 'NoSuchBucket':
                print(f"Error: Bucket '{bucket}' does not exist", file=sys.stderr)
                sys.exit(1)
            raise
        
        # Build parameters - include Content-Type to match what browser will send
        params = {
            'Bucket': bucket, 
            'Key': key,
            'ContentType': 'application/octet-stream'
        }
        
        url = s3_client.generate_presigned_url(
            'put_object',
            Params=params,
            ExpiresIn=expiration
        )
        return url
    except NoCredentialsError:
        print("Error: AWS credentials not found. Configure with 'aws configure'", file=sys.stderr)
        sys.exit(1)
    except ClientError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(
        description='Generate presigned S3 PUT URL'
    )
    parser.add_argument('filename', nargs='?', help='Filename to use as S3 key (optional if --key is provided)')
    parser.add_argument('--bucket', '-b', help='S3 bucket name')
    parser.add_argument('--key', '-k', help='S3 object key (required if filename not provided)')
    parser.add_argument('--region', '-r', help='AWS region')
    parser.add_argument('--expires', '-e', type=int, default=3600,
                        help='URL expiration in seconds (default: 3600)')
    parser.add_argument('--upload-page', '-u', default='https://tinyemail.github.io/tiny-poc/upload.html',
                        help='Upload page URL (default: https://tinyemail.github.io/tiny-poc/upload.html)')
    
    args = parser.parse_args()
    
    # Get bucket name
    bucket = args.bucket or os.environ.get('S3_BUCKET')
    if not bucket:
        print("Error: Bucket name required (use --bucket or set S3_BUCKET env var)", file=sys.stderr)
        sys.exit(1)
    
    # Use provided key or filename
    key = args.key or args.filename
    if not key:
        print("Error: Either filename or --key is required", file=sys.stderr)
        sys.exit(1)
    
    # Generate presigned URL
    presigned_url = generate_presigned_put_url(bucket, key, args.expires, args.region)
    
    # Generate upload page URL with encoded presigned URL
    encoded_presigned_url = quote(presigned_url, safe='')
    upload_page_url = f"{args.upload_page}?url={encoded_presigned_url}"
    
    # Print both URLs
    print("Presigned URL:")
    print(presigned_url)
    print("\nUpload Page URL:")
    print(upload_page_url)

if __name__ == '__main__':
    main()