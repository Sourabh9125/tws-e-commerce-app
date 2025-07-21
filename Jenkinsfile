@Library('Shared') _
pipeline {
    agent any
    environment{
        DOCKERHUB_USERNAME = "sourabhlodhi"
        DOCKER_IMAGE_NAME = "easyshop-app"
        DOCKER_MIGRATION_IMAGE_NAME = "easyshop-migration"
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_BRANCH = "production"
        GIT_URL = "https://github.com/Sourabh9125/tws-e-commerce-app.git"
     }
    stages {
        stage("Clean Workspace") {
            steps {
                script {
                    clean_ws()
                }
                
            }
        }
        stage("Code Cloning") {
            steps {
                script {
                    clone(env.GIT_URL ,env.GIT_BRANCH)
                }
                
            }
        }
        stage("Build Docker Image") {
            parallel{
                stage("Build Docker Image easyshop") {
                  steps {
                     script {
                         docker_build(
                              imageName: env.DOCKER_IMAGE_NAME,
                              imageTag: env.DOCKER_IMAGE_TAG,
                              context: ".",
                              dockerfile: "Dockerfile"
                        )
                }
                
            }
        }
                stage("Build Docker Image migration") {
                   steps {
                      script {
                           docker_build(
                                imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                context: ".",
                                dockerfile: "scripts/Dockerfile.migration"
                        )
                }
                
            }
        }
            }
        }
        stage("Security scanning using trivy") {
            steps {
                script {
                    trivy()
                }
                
            }
        }
        stage("Push TO DockerHub") {
            parallel {
                stage("DockerHub easyshop Image") {
                    steps {
                        script {
                            docker_hub(
                                credentialsId: "dockerHubId",
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG
                            )
                       }
                 }
            }
         stage("DockerHub migration Image") {
             steps {
                 script {
                     docker_hub(
                         credentialsId: "dockerHubId",
                         imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                         imageTag: env.DOCKER_IMAGE_TAG
                     )
                 }
             }
         }
     }
}

        stage("update kubernetes Manifests") {
            steps {
                script {
                    update_k8s_manifest(
                        imageTag: env.DOCKER_IMAGE_TAG,
                        imageName: env.DOCKER_IMAGE_NAME,
                        imageMigration: env.DOCKER_MIGRATION_IMAGE_NAME,
                        gitCredentials: "gitHubCred",
                        gitUserName: "Sourabh9125",
                        gitUserEmail: "lodhisaurabh9125@gmail.com",
                        dockerHubUserName: env.DOCKERHUB_USERNAME
                        )
                }
                
            }
        }
    }
}
