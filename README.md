# Node.js sample app on OpenShift!
-----------------

This example will serve a welcome page and the current hit count as stored in a database.

## Prerequisites

1. An IBM Cloud Account. Create one at https://cloud.ibm.com/registration
1. Clone this repo

```bash
git clone https://github.com/odrodrig/nodejs-example.git
```

## Accessing the environment

1. Access the lab request url handed to you by the instructor

1. One the new page enter the lab key as given by the instructor as well as the email address you used to create your IBM Cloud account.

1. You will then be given access to an OpenShift Cluster. Log into IBM Cloud or click on the link supplied to you after the cluster granting process to find the assigned cluster.

## SonarQube lab

To access the SonarQube lab, navigate to https://ibm.github.io/sonarqube/get-started-with-sonarqube/ 

This lab can be done locally or on a hosted development environment.

## Accessing Harbor

The Harbor registry can be found at:  https://core.oliver-openshift-4-5-2bef1f4b4097001da9502000c44fc2b2-0000.us-east.containers.appdomain.cloud/.

Navigate to the registry and create an account to be able to access the images in the registry.

## Testing out a deployment

1. From your terminal locally, first authenticate with OpenShift by copying the login url from the OpenShift Console.

1. Then, navigate to your appropriate project.

1. Navigate to the directory where this repo was cloned if you haven't already.

        ```bash
        cd nodejs-example/
        ```

1. Apply all of the files in the deploy directory with:

        ```bash
        oc apply -f deploy/
        ```

This should deploy a sample nodejs application to our repo utilizing an image stored in Harbor.

## Utilizing OpenShift Pipelines

To utilize OpenShift pipelines we need to configure our `pipeline` service account to be able to authenticate with Harbor.

1. Since we are using OpenShift Pipelines, a new service account should have been added called `pipeline`.

1. We need to create a secret that contains our credentials for connecting to Harbor. In your terminal, run the following command to create the secret replacing `username_here` and `password_here` with the appropriate values from your Harbor account: 

```bash
oc create secret docker-registry harbor-user --docker-username="username_here" --docker-password="password_here" --docker-server="https://core.oliver-openshift-4-5-2bef1f4b4097001da9502000c44fc2b2-0000.us-east.containers.appdomain.cloud/"
```

1. Then we need to modify the service account to be able to use the secret:

```bash
oc patch sa pipeline -p '{"secrets": [{"name": "harbor-user"}]}'
```

1. Now we can apply the pipeine files 

        ```bash
        oc apply -f pipeline/tasks/
        oc apply -f pipeline/pipeline.yaml
        ```

1. Open the pipeline/pipelineRun/build-deploy-pipelinerun.yaml file and modify the tag at the end of the Image param to be a unique image name. For example, the default image is `nodejs-example` but you can modify the image name to include your initials, like `odr-nodejs-example`. The tag after the image can be set to `:1` but will need to increment by one every time you run the pipeline.

1. We can run the pipeline with:

        ```bash
        oc create -f pipeline/pipelineRun/build-deploy-pipelinerun.yaml
        ```

1. You can then navigate to the OpenShift web console and find the `Pipelines` section on the left nav bar and click on `Pipeline Runs` to view the status of your build.

Once the pipeline is complete you can go back to Harbor, sign in, and view the built images.