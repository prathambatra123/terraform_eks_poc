pipeline {

   parameters {
    choice(name: 'action', choices: 'create\ndestroy', description: 'Create/update or destroy the eks cluster.')
    string(name: 'instance_type', defaultValue : 'm5.large', description: "k8s worker node instance type.")
    string(name: 'num_workers', defaultValue : '3', description: "k8s number of worker instances.")
    string(name: 'max_workers', defaultValue : '10', description: "k8s maximum number of worker instances that can be scaled.")
    string(name: 'credential', defaultValue : 'aws-jenkins', description: "Jenkins credential that provides the AWS access key and secret.")
    string(name: 'key_pair', defaultValue : 'home', description: "EC2 instance ssh keypair.")
    string(name: 'region', defaultValue : 'us-east-1', description: "AWS region.")
  }

  agent any

  stages {
  
    stage('Preparation') { 
        
        steps {
         git branch: 'main', url: 'https://github.com/prathambatra123/terraform_eks_poc.git'
        }
    }
	
    stage('TF Plan') {
      when {
        expression { params.action == 'create' }
      }
      steps {
        script {
            sh "cd /tmp"
            sh "rm -rf terraform_0.12.2_linux_amd64.zip"
            sh "wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip"
            sh "unzip -o terraform_0.12.2_linux_amd64.zip"
        
            sh "sudo cp -f terraform /usr/bin/"

            sh """
               terraform init
               terraform plan -input=false -out=tfplan
            """
          
		  }
        }
      }
    

    stage('TF Apply') {
      when {
        expression { params.action == 'create' }
      }
      steps {
        script {
          
            sh """
              terraform apply -auto-approve
            """
          
        }
      }
    }

    stage('Cluster and pod setup') {
      when {
        expression { params.action == 'create' }
      }
      steps {
        script {
            sh """
              aws eks update-kubeconfig --name eks-demo --region ${params.region}
			  sudo curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.12/2020-11-02/bin/linux/amd64/kubectl
			  sudo chmod +x ./kubectl
			  sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
			  echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
			  kubectl apply -f ubuntu.yaml

            """

         }
    }
	}
/*	stage('Scan') {
	    when {
        expression { params.action == 'create' }
      }
	    steps {
        snykSecurity organisation: 'prathambatra123', projectName: 'f1dd0cfc-e568-43ab-bfc2-af1623d4f4d1', snykInstallation: 'snyk', snykTokenId: 'snyk-id', targetFile: 'ubuntu.yaml'
    }
	}*/
    stage('TF Destroy') {
      when {
        expression { params.action == 'destroy' }
      }
      steps {
        script {
          sh """
              terraform destroy -auto-approve
            """
          
        }
      }
    }

  }

}
