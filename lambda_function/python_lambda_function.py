import boto3
import os
import logging
from PIL import Image
from io import BytesIO

# getting logger and setting log-level
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')

def remove_exif_from_image(file_content):
    image_object = Image.open(BytesIO(file_content))
    image_object = image_object.convert('RGB')

    # Save the image without EXIF data
    output_stream = BytesIO()
    image_object.save(output_stream, format='JPEG', quality=95)
    output_stream.seek(0)

    return output_stream


def lambda_handler(event, context):
    
    logger.info("New files uploaded to the source bucket..")

    # Download the file
    try:
        source_bucket = event['Records'][0]['s3']['bucket']['name']
        destination_bucket = os.environ['destination_bucket']    
        key = event['Records'][0]['s3']['object']['key']
        
        s3_object = s3_client.get_object(Bucket=source_bucket, Key=key)
        file_content = s3_object['Body'].read()
    except Exception as error:
        logger.error(f'There was an error downloading the file from the bucket')
        logger.error(f'Error: {error}')
    
    # check if the file is a .jpg image then remove exif data
    try: 
        if key.lower().endswith(('.jpg')):
            output_stream = remove_exif_from_image(file_content)
        else:
            logger.error(f'Unsupported file format![Required: .jpg ]') 
    except Exception as error:
        logger.error(f'There was an error in removing EXIF data from the image: {error}')       


    # upload file to the destination bucket        
    try:
        s3_client.put_object(Bucket=destination_bucket, Key=key, Body=output_stream)
        logger.info(f'File successfully uploaded to the destination bucket: {destination_bucket}')
                
    except Exception as error:
        logger.error(f'There was an error uploading the file to the destination bucket: {destination_bucket}')
        logger.error(f'Error Message: {error}')