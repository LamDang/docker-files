#! /bin/bash
## Build tests
image_name="30_deeplearning:test"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Building test image"
docker build -t ${image_name} $DIR

## Run tests
echo "Test cuda"
nvidia-docker run --rm ${image_name} nvidia-smi
echo "Test theano"
nvidia-docker run --rm ${image_name} python -c "import theano"
echo "Test keras w theano"
nvidia-docker run --rm ${image_name} bash -c "KERAS_BACKEND=theano \
    python -c 'import keras; print(keras.__version__)'"
echo "Test tensorflow"
nvidia-docker run --rm ${image_name} python -c "import tensorflow"
echo "Test mkl"
docker run --rm ${image_name} python -c "from sklearn.tests.test_kernel_ridge import test_kernel_ridge; test_kernel_ridge()"

## Clean up
docker rmi ${image_name}
