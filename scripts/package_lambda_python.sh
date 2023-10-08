#!/bin/bash

echo "Creating package lambda python... "

cd $path_cwd
echo "$path_cwd"

dir_name=lambda_distribution_package/
mkdir $dir_name

#for local testing only
#if [ -z ${runtime+x} ]; then runtime="python3.10" ; else echo "var is set to '$runtime'"; fi
#if [ -z ${function_name+x} ]; then function_name="lambda-exif"; else echo "var is set to '$function_name'"; fi

# virtual environment setup
virtualenv -p $runtime python_env_$function_name
source $path_cwd/python_env_$function_name/bin/activate

# python dependencies installation...
FILE=$path_cwd/lambda_function/requirements.txt

if [ -f "$FILE" ]; then
  echo "requirement.txt file exists..."
  echo "Installing dependencies..."
  pip install -r "$FILE"

else
  echo "Error: requirement.txt file does not exist!"
fi

# removing python virtual environment...
deactivate

# Building deployment package for python lambda function...
echo "Building deployment package for python lambda function..."

cd python_env_$function_name/lib/$runtime/site-packages/
cp -r . $path_cwd/$dir_name
cp -r $path_cwd/lambda_function/ $path_cwd/$dir_name

# Removing virtual environment folder...
echo "Removing virtual environment folder..."
rm -rf $path_cwd/python_env_$function_name

echo "Package lambda python created successfully"
