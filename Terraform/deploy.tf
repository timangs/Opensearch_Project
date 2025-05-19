# # 코드 배포용 CodeDeploy Application 생성
# resource "aws_codedeploy_app" "web_app" {
#   name             = "web-server"
#   compute_platform = "Server" # EC2나 온프레미스 서버를 의미

# }


# # 해당 Apllication에 종속되는 배포그룹 생성
# resource "aws_codedeploy_deployment_group" "web_dg" {
#   depends_on            = [aws_autoscaling_group.asg]
#   app_name              = aws_codedeploy_app.web_app.name
#   deployment_group_name = "webapp-deployment-group"
#   service_role_arn      = aws_iam_role.codedeploy_role.arn

#   deployment_config_name = "CodeDeployDefault.AllAtOnce" # 배포 방식: 전부 한 번에 (테스트환경에서 쓰고, 이후 HalfAtATime 으로 변경 예정)

#   autoscaling_groups = [aws_autoscaling_group.asg.id]



#   deployment_style {
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#     deployment_type   = "BLUE_GREEN"
#   }


#   blue_green_deployment_config {

#     deployment_ready_option {
#       action_on_timeout = "CONTINUE_DEPLOYMENT"
#     }

#     green_fleet_provisioning_option {
#       action = "COPY_AUTO_SCALING_GROUP"
#     }

#     terminate_blue_instances_on_deployment_success {
#       action                           = "TERMINATE"
#       termination_wait_time_in_minutes = 0
#     }
#   }

#   load_balancer_info {
#     target_group_info {
#       name = aws_lb_target_group.web_tg.name
#     }
#   }

#   # 연결 완료 후 기존의 리소스 (asg) 삭제
#   lifecycle {
#     create_before_destroy = true
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }
# }

# #싱가포르 배포

# resource "aws_codedeploy_app" "sin_web_app" {
#   provider         = aws.singapore
#   name             = "sin-web-server"
#   compute_platform = "Server"
# }

# resource "aws_codedeploy_deployment_group" "sin_web_dg" {
#   provider                = aws.singapore
#   depends_on              = [aws_autoscaling_group.sin_asg]
#   app_name                = aws_codedeploy_app.sin_web_app.name
#   deployment_group_name   = "sin-webapp-deployment-group"
#   service_role_arn        = aws_iam_role.codedeploy_role.arn

#   deployment_config_name  = "CodeDeployDefault.AllAtOnce"

#   autoscaling_groups      = [aws_autoscaling_group.sin_asg.id]

#   deployment_style {
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#     deployment_type   = "BLUE_GREEN"
#   }

#   blue_green_deployment_config {
#     deployment_ready_option {
#       action_on_timeout = "CONTINUE_DEPLOYMENT"
#     }
#     green_fleet_provisioning_option {
#       action = "COPY_AUTO_SCALING_GROUP"
#     }
#     terminate_blue_instances_on_deployment_success {
#       action                           = "TERMINATE"
#       termination_wait_time_in_minutes = 0
#     }
#   }

#   load_balancer_info {
#     target_group_info {
#       name = aws_lb_target_group.sin_web_tg.name
#     }
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }
# }



# # CodePipeline 생성
# # resource "aws_codepipeline" "web_pipeline" {
# #   name     = "webapp-pipeline"
# #   role_arn = aws_iam_role.codepipeline_role.arn

# #   artifact_store {
# #     location = aws_s3_bucket.my_pipelines_first_artifact_bucket.bucket
# #     type     = "S3"

# #     encryption_key {
# #       id   = "alias/aws/s3"
# #       type = "KMS"
# #     }
# #   }


# #   # 1단계: Source (GitHub → ZIP)
# #   stage {
# #     name = "Source"

# #     action {
# #       name             = "GitHub_Source"
# #       category         = "Source"
# #       owner            = "AWS"
# #       provider         = "CodeStarSourceConnection"
# #       version          = "1"
# #       output_artifacts = ["SourceOutput"]

# #       configuration = {
# #         ConnectionArn    = "arn:aws:codeconnections:us-east-1:248189921892:connection/f58fa5ca-9f80-4c75-b270-e1db80975efd" //원빈 쪽 repo 요청 승인 후 연결생성 & 해당 연결 arn 정보 입력할 예정!
# #         FullRepositoryId = "NoJamBean/Revolution"
# #         BranchName       = var.github_branch
# #         DetectChanges    = "true"
# #       }

# #       run_order = 1
# #     }
# #   }


# #   # 2단계: Build (CodeBuild 실행)
# #   stage {
# #     name = "Build"

# #     action {
# #       name             = "Build_App"
# #       category         = "Build"
# #       owner            = "AWS"
# #       provider         = "CodeBuild"
# #       version          = 1
# #       input_artifacts  = ["SourceOutput"]
# #       output_artifacts = ["BuildOutput"]

# #       configuration = {
# #         ProjectName = aws_codebuild_project.app_build.name
# #       }

# #       run_order = 1
# #     }
# #   }


# #   # 3단계: Deploy (CodeDeploy 호출)
# #   stage {
# #     name = "Deploy"

# #     action {
# #       name            = "Deploy_App"
# #       category        = "Deploy"
# #       owner           = "AWS"
# #       provider        = "CodeDeploy"
# #       version         = 1
# #       input_artifacts = ["BuildOutput"]

# #       configuration = {
# #         ApplicationName     = aws_codedeploy_app.web_app.name
# #         DeploymentGroupName = aws_codedeploy_deployment_group.web_dg.deployment_group_name
# #       }

# #       run_order = 1
# #     }
# #   }

# #   tags = {
# #     Name        = "WebAppCodePipeline"
# #     Environment = "dev"
# #   }
# # }




# # git v2 용 connection [git Token인증 대체방안] - (apply 후 aws 콘솔 들어가서 직접 승인확인 해야함!)
# # resource "aws_codestarconnections_connection" "github" {
# #   name          = "github-connection"
# #   provider_type = "GitHub"
# # }


# # CodePipeline 자동 트리거용 webhook 생성 (Git v1용 - [v2에서 사용안함])
# # resource "aws_codepipeline_webhook" "github_webhook" {
# #   name            = "webapp-pipeline-webhook"
# #   target_pipeline = aws_codepipeline.web_pipeline.name
# #   target_action   = "GitHub_Source" # Source 스테이지의 액션 이름과 동일해야 함
# #   authentication  = "GITHUB_HMAC"

# #   authentication_configuration {
# #     secret_token = var.github_webhook_secret
# #   }

# #   filter {
# #     json_path    = "$.ref"
# #     match_equals = "refs/heads/${var.github_branch}" //최종 프로젝트 시 수정(main으로)
# #   }

# #   tags = {
# #     Environment = "dev"
# #   }
# # }
