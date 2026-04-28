pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: IfNotPresent
    command: [ "/busybox/cat" ]
    tty: true
    volumeMounts:
      - name: kaniko-conf
        mountPath: /kaniko/.docker
  volumes:
    - name: kaniko-conf
      emptyDir: {}
"""
        }
    }

    environment {
        REGISTRY = "harbor.bilgem.tubitak.gov.tr"
        PROJECT  = "tmp"
        IMAGE_NAME = "idil-redis" // İstediğin ismi verebilirsin
        IMAGE_TAG  = "${env.BUILD_NUMBER}" // Her build'e ayrı numara!
        USER = "idilsu.elmas"
        PASS = "GokayEldemdeas173422.*"
    }

    stages {
        stage('1. Kodu Çek') {
            steps {
                git branch: 'main', url: 'https://github.com/delavenka/jenkins-examples.git'
            }
        }

        stage('2. Harbor Auth') {
            steps {
                container('kaniko') {
                    sh """
                    AUTH_BASE64=\$(echo -n "${USER}:${PASS}" | base64 | tr -d '\\n')
                    echo "{\\\"auths\\\":{\\\"${REGISTRY}\\\":{\\\"auth\\\":\\\"\$AUTH_BASE64\\\"}}}" > /kaniko/.docker/config.json
                    """
                }
            }
        }

        stage('3. Kaniko ile Build ve Harbor Push') {
            steps {
                container('kaniko') {
                    // Kaniko hem build yapar hem de otomatik pushlar
                    sh """
                    /kaniko/executor \
                    --context=${WORKSPACE} \
                    --dockerfile=${WORKSPACE}/Dockerfile \
                    --destination=${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${IMAGE_TAG} \
                    --insecure --skip-tls-verify
                    """
                }
            }
        }

        stage('4. Sonuç Kontrol') {
            steps {
                echo "İşlem bitti! Harbor'da ${IMAGE_NAME}:${IMAGE_TAG} imajini kontrol et."
            }
        }
    }
}
