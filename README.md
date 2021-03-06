# Docker stack for data science tools

This docker stack is organized in "steps" each step add some new environment to the tool.
Each step should be independent and provide a runnable image.
* 00_jupyter_setup: Configure user name and home directory
* 10_anaconda: Add Anaconda and config Jupyter Notebook
* 20_add_packages: Add other Data Science Package
* 30_deeplearning: Add Keras, Theano, TensorFlow with GPU config

## User guide
### Launch a Jupyter Notebook server
`sudo docker run` [Docker Options] [Image Name] `start-notebook.sh` [Notebook Options]

### Docker Options:
#### Standard options:
* `-d --restart=unless-stopped` - Run in detached mode and always restart container except manually stopped
* `-p [host_port]:[contaier_port]` - Map container port to specific host port
* `-e GEN_CERT=yes` - Use HTTPS - certificates is automatically generated.
* `-e GRANT_SUDO=yes` - NOT SECURED: give passwordless sudo to user
* `-e NB_UID=[your_uid] --user root` - Set notebook user UID. This is important to control the permissions of files mounted from host or future files created by the container
* `-v [host_absolute_path]:[container_absolute_path]` - Mount a host folder to container. It is recommended to use absolute path to avoid confusion

#### Integrate Spark to Jupyter Notebook:
* Deploy Spark to host server using Hadoop distribution
* When launching container:
    * Mount the following folders:
        * Spark installation folder
        * Yarn and Hive config folder
    * Network:
        * Set hostname of container to server hostname
        * Open a range of ports for Spark components
    * Set environment variables:
        * SPARK_HOME
        * PYTHON_PATH: to include $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip
        * PYSPARK_PYTHON: path to Python ($CONDA_DIR/bin/python)

#### Run Jupyter with GPU & CUDA deep learning:
* **Prerequisites:**
  * Have CUDA capable GPU installed with driver
  * Install CUDA toolkit
  * Install nvidia-docker and nvidia-docker-plugin: https://github.com/NVIDIA/nvidia-docker/wiki/Installation
* **How:** 
  * Using nvidia-docker wrapper: Run container as usual by replacing _sudo docker_ with _sudo nvidia-docker_  
  * Without wrapper:
    * Cf. details in: https://github.com/NVIDIA/nvidia-docker/wiki/NVIDIA-driver#alternatives

### Notebook options
* Password: `--NotebookApp.password='sha1:....'` (use hashed password)
* Use a different port `--NotebookApp.port : Int`
