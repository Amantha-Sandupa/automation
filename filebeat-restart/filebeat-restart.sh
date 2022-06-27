pipeline {
  agent any
  options {
        ansiColor('xterm')
    }
    stages {
        
        stage('ssh and restart filebeat') {
            steps {
                  sshagent(credentials: ['jenkins-openvpn']){
                    sh "ssh -o StrictHostKeyChecking=no -l jenkins ${SERVER_IP} 'hostname && whoami && sudo systemctl restart filebeat && sudo systemctl status filebeat && sudo df -h'"
                  
              }
            }
        }
        
   }
   post {

        success {
            echo "\033[42m Filebeat service successfully restarted on ${SERVER_IP} \033[0m"
        }

    }
   
}