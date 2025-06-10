**1. 개발 목적**

이 시스템의 주요 개발 목적은 다음과 같습니다.

- **중앙 집중식 가시성 확보:** 분산된 상태로 존재하는 여러 소스(RDS, EC2, 애플리케이션, CloudTrail)의 메트릭과 로그를 OpenSearch로 통합하여 단일 대시보드에서 전체 시스템 상태를 파악합니다.
- **실시간/준실시간 모니터링:** CloudWatch Stream, Firehose, Lambda를 통해 메트릭과 로그를 빠르게 수집하여 시스템 운영 및 사용자 활동을 실시간에 가깝게 모니터링합니다.
- **운영 효율성 증대:** 인프라(EC2, RDS) 성능 메트릭을 시각화하여 장애 징후를 조기에 감지하고, 애플리케이션 로그를 분석하여 문제 해결 시간을 단축합니다.
- **사용자 행동 및 서비스 선호도 분석:** Access Log에서 Request Parameter를 추출하여 사용자들이 어떤 서비스나 기능에 관심 있는지 파악하고 서비스 개선 방향을 도출합니다.
- **보안 분석 및 위협 탐지:** CloudTrail과 Access Log의 SourceIPAddress를 지리 정보와 매핑하여 비정상적인 접근 시도나 특정 지역에서의 활동 패턴을 분석하고 보안 위협에 대응합니다.
- **데이터 기반 의사결정 지원:** 수집된 모든 데이터를 기반으로 의미 있는 대시보드를 구성하여 비즈니스 및 기술적 의사결정을 지원합니다.

![image.png](attachment:10f97972-6f1c-4d25-9449-d7788d834ac9:image.png)

**2. 결과**
![image.png](attachment:93fcc435-397b-4ab0-962e-f2197aaf62df:image.png)
![image.png](attachment:059cd5df-1ffb-47fa-9eb3-de899365c636:image.png)
![image.png](attachment:023259ea-8b15-4e1f-8c35-0a817f0fb2d9:image.png)
**3. 시각화 및 분석 레이어:**
  - **도구:** OpenSearch Dashboards
  - **구성된 대시보드 요소:**
      1.  CloudTrail Dashboard
          **Visualize 패널 목록:**
          - `CloudTrail_CoordinateMap_사용량` (`type: tile_map`): CloudTrail 로그 발생 위치의 지리적 분포를 지도에 표시합니다.
          
          ![image.png](attachment:47503666-a49b-426d-abcb-fc3f7ce3b050:image.png)
          
          - `CloudTrail_visualization_리전별로그수` (`type: visualization-visbuilder`, 메트릭/그룹 메트릭 형태): AWS Region별 CloudTrail 로그 수를 메트릭 또는 간단한 차트로 보여줍니다.
          
          ![image.png](attachment:4d6736ce-fb6c-47b6-a631-63b7dd0bee52:image.png)
          
          - `CloudTrail_Pie_이벤트_CUD` (`type: pie`): Create, Update, Delete 등 중요한 `eventName`을 가진 CloudTrail 이벤트의 비율을 파이 차트로 표시합니다. (Discover: `CloudTrail_Discover_CUD`를 기반으로 함)
          
          ![image.png](attachment:9a8726bc-442b-4cfd-a0a8-aea7d23218ca:image.png)
          
          - `CloudTrail_Pie_에러코드` (`type: pie`): CloudTrail 로그에서 발생하는 오류의 `errorCode`별 비율을 파이 차트로 표시합니다.
          
          ![image.png](attachment:0b8622b6-7c74-4358-a8ce-2de4dba7a240:image.png)
          
          - `CloudTrail_Area_사용자` (`type: horizontal_bar`): 사용자(`userIdentity.userName`)별 CloudTrail 이벤트 수의 시간 추세를 가로 막대 차트로 표시합니다.
          
          ![image.png](attachment:4ae79041-9235-499e-9008-ae8a4427634a:image.png)
          
          - `CloudTrail_Area_사용량` (`type: line`): AWS Region(`awsRegion`)별 CloudTrail 이벤트 수의 시간 추세를 라인 차트로 표시합니다. (참고: VisState에는 `line`으로 정의되어 있습니다.)
          
          ![image.png](attachment:c673ae57-e8e8-4886-961c-be69c8e82ce2:image.png)
          
          Discover 패널 목록:
          
          - `CloudTrail_Discover_CUD` (`type: search`): CloudTrail 로그 중에서 `Describe*`, `List*`, `Get*`, `AssumeRole` 등 조회성 이벤트를 제외한(즉, Create, Update, Delete 등 변경 이벤트를 포함하는) 로그들의 상세 내역을 테이블 형태로 보여줍니다. (`userIdentity.userName`, `eventName`, `sourceIPAddress`, `sourceDomain` 컬럼 등을 표시)
          
          ![image.png](attachment:4c0220aa-5b1c-4588-8fda-bf2fc69d72a0:image.png)
          
      2. RDS Metric Dashboard
          
          **Visualize 패널 목록:**
          
          - `RDS_Metric_Gauge_메모리사용량` (`type: gauge`): RDS `FreeableMemory` 메트릭의 평균값을 게이지 형태로 표시합니다.
          
          ![image.png](attachment:a93295f2-72d7-42c5-9d38-0540059bb93c:image.png)
          
          - `RDS_Metric_Gauge_스토리지용량` (`type: gauge`): RDS `BinLogDiskUsage` 메트릭의 평균값을 게이지 형태로 표시합니다.
          
          ![image.png](attachment:637df933-43ae-4422-a523-025c96eca75f:image.png)
          
          - `RDS_Metric_Line_IOPS` (`type: area`): RDS `ReadIOPS` 및 `WriteIOPS` 메트릭의 평균값 시간 추세를 라인 또는 영역 차트로 표시하며, `metric_name`과 `DBInstanceIdentifier`별로 그룹화합니다.
          
          ![image.png](attachment:1fa21e85-2ed8-44e4-9324-d8eba03831cb:image.png)
          
          - `RDS_Metric_Metric_연결수` (`type: metric`): RDS `DatabaseConnections` 메트릭의 최대값을 단일 메트릭으로 표시하며, `DBInstanceIdentifier`별로 그룹화합니다.
          
          ![image.png](attachment:89f3de8c-93f8-4755-ace7-5737eaa09233:image.png)
          
          - `RDS_Metric_Line_Throughput` (`type: line`): RDS `WriteThroughput`, `ReadThroughput`, `NetworkTransmitThroughput` 메트릭의 평균값 시간 추세를 라인 차트로 표시하며, `metric_name`별로 그룹화합니다.
          
          ![image.png](attachment:96ad650d-866c-4e16-8eef-5c5ea7938156:image.png)
          
          - `RDS_Metric_Line_메모리사용량` (`type: line`): RDS `FreeableMemory` 메트릭의 평균값 시간 추세를 라인 차트로 표시하며, `DBInstanceIdentifier`별로 그룹화합니다.
          
          ![image.png](attachment:05ab3bb5-4a82-4d12-b219-f09fd8ad9e92:image.png)
          
      
      3. Application Dashboard
      
      **Visualize 패널 목록:**
      
      - `EC2_Metric_Hitmap_CPUUtilization` (`type: heatmap`): `ec2-*` 인덱스에서 EC2 `CPUUtilization` 메트릭의 최대값을 시간과 `InstanceId`별로 그룹화하여 히트맵으로 표시합니다.
      
      ![image.png](attachment:93bc12c7-83a1-4020-965e-d8f005ebd046:image.png)
      
      ![image.png](attachment:2773948e-70a4-4ab9-83ab-2bb17c970a75:image.png)
      
      - `Application_CoordinateMap_한국` (`type: tile_map`): `web-*` 인덱스에서 Application Access Log의 `geoip.location` (한국 내) 정보를 지도에 표시합니다.
      
      ![image.png](attachment:6f955318-59a7-4403-ae66-d1f31c7fed6f:image.png)
      
      - `Application_TagCloud_스포츠선호도` (`type: tagcloud`): `web-*` 인덱스에서 Application Access Log의 `url.query_params.sport` 필드 값의 빈도를 태그 클라우드로 표시하여 인기 스포츠를 보여줍니다.
      
      ![image.png](attachment:245f1016-3bdb-4d2a-94a3-a278839399a3:image.png)
      
      - `Application_CoordinateMap_세계지도` (`type: tile_map`): `web-*` 인덱스에서 Application Access Log의 `geoip.location` (전 세계) 정보를 지도에 표시합니다.
      
      ![image.png](attachment:141bac3d-db9b-4cac-af12-af594253da97:image.png)
      
      - `Application_Pie_이벤트` (`type: pie`): `web-*` 인덱스에서 Application Access Log의 `eventName.keyword` 필드 값의 빈도를 파이 차트로 표시합니다.
      
      ![image.png](attachment:611171c7-1aa3-485e-ba72-53ba60c90613:image.png)
      
      - `EC2_Metric_Area_네트워크` (`type: line`): `ec2-*` 인덱스에서 EC2 `NetworkpacketsIn과 NetworkpacketOut` 메트릭의 평균값 시간 추세를 영역 차트로 표시하며, `InstanceId`별로 그룹화합니다.
      
      ![image.png](attachment:38b87fa4-8487-4383-9ae2-38cb94d7e6e5:image.png)
      
      - `EC2_Metric_Line_EBS사용량` (`type: bar`): `ec2-*` 인덱스에서 EC2 `EBSWriteBytes` 및 `EBSReadBytes` 메트릭의 최대값 시간 추세를 Bar 차트로 표시하며, 필터 및 `InstanceId`별로 그룹화합니다.
      
      ![image.png](attachment:9d467b6e-b87e-4e4e-827d-c8870947d939:image.png)
      
      **Discover 패널 목록:**
      
      - `Application_Discover_NotRouting` (`type: search`): `web-*` 인덱스에서 Application Access Log 중 `eventName`이 'PageRouting'이 아닌 로그들의 상세 내역을 테이블 형태로 보여줍니다.
    
      ![image.png](attachment:412b9917-3251-4c9e-8a3f-5dd9f0010f22:image.png)
    
