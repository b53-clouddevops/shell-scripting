pipeline{
    agent any
    environment {
        ABC_URL = "test.google.com"
        XYZ_URL = ""
    }
    stages{
        stage("A"){
            steps {
                sh "echo ========executing A======== "
                sh "echo value of ABC_URL is ${ABC_URL}"
                sh "echo value of XYZ_URL is ${XYZ_URL}"
            }
        }
        stage("B"){
            steps {
                sh "echo ========executing b======== "
                script {
                    if(${ABC_URL} != null) {
                        echo value of ABC_URL is ${ABC_URL}
                    } else {
                        echo value is empty : ${ABC_URL}
                        }

                    }
                }
            }
        }
    }
