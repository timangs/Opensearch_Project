**1. 개발 목적**

이 시스템의 주요 개발 목적은 다음과 같습니다.

- **중앙 집중식 가시성 확보:** 분산된 상태로 존재하는 여러 소스(RDS, EC2, 애플리케이션, CloudTrail)의 메트릭과 로그를 OpenSearch로 통합하여 단일 대시보드에서 전체 시스템 상태를 파악합니다.
- **실시간/준실시간 모니터링:** CloudWatch Stream, Firehose, Lambda를 통해 메트릭과 로그를 빠르게 수집하여 시스템 운영 및 사용자 활동을 실시간에 가깝게 모니터링합니다.
- **운영 효율성 증대:** 인프라(EC2, RDS) 성능 메트릭을 시각화하여 장애 징후를 조기에 감지하고, 애플리케이션 로그를 분석하여 문제 해결 시간을 단축합니다.
- **사용자 행동 및 서비스 선호도 분석:** Access Log에서 Request Parameter를 추출하여 사용자들이 어떤 서비스나 기능에 관심 있는지 파악하고 서비스 개선 방향을 도출합니다.
- **보안 분석 및 위협 탐지:** CloudTrail과 Access Log의 SourceIPAddress를 지리 정보와 매핑하여 비정상적인 접근 시도나 특정 지역에서의 활동 패턴을 분석하고 보안 위협에 대응합니다.
- **데이터 기반 의사결정 지원:** 수집된 모든 데이터를 기반으로 의미 있는 대시보드를 구성하여 비즈니스 및 기술적 의사결정을 지원합니다.

![image](https://github.com/user-attachments/assets/cd5e68bb-3308-4b0a-857a-ba0b80ad0d31)

**2. 결과**
![image](https://github.com/user-attachments/assets/1e000a6f-8297-4f6a-aaef-aff5f293d50c)

![image](https://github.com/user-attachments/assets/d7978661-7cf5-404a-9660-abd02dc72307)

![image](https://github.com/user-attachments/assets/a30b670f-5f67-4bdb-bd6f-f6fe9ede5693)

**3. 시각화 및 분석 레이어:**
  - **도구:** OpenSearch Dashboards
  - **구성된 대시보드 요소:**
      1.  CloudTrail Dashboard
          **Visualize 패널 목록:**
          - `CloudTrail_CoordinateMap_사용량` (`type: tile_map`): CloudTrail 로그 발생 위치의 지리적 분포를 지도에 표시합니다.
          
          ![image](https://github.com/user-attachments/assets/f0f4f281-b4a4-4242-9cdf-3bc9443fcb61)
          
          - `CloudTrail_visualization_리전별로그수` (`type: visualization-visbuilder`, 메트릭/그룹 메트릭 형태): AWS Region별 CloudTrail 로그 수를 메트릭 또는 간단한 차트로 보여줍니다.
          
          ![image](https://github.com/user-attachments/assets/c97e2526-5685-456e-93db-511e4c7bbcb6)
          
          - `CloudTrail_Pie_이벤트_CUD` (`type: pie`): Create, Update, Delete 등 중요한 `eventName`을 가진 CloudTrail 이벤트의 비율을 파이 차트로 표시합니다. (Discover: `CloudTrail_Discover_CUD`를 기반으로 함)
          
          ![image](https://github.com/user-attachments/assets/b6cbc1bf-a9ea-4efd-90c7-b7a7ec128380)

          
          - `CloudTrail_Pie_에러코드` (`type: pie`): CloudTrail 로그에서 발생하는 오류의 `errorCode`별 비율을 파이 차트로 표시합니다.
          
          ![image](https://github.com/user-attachments/assets/c5cb15be-0b7b-4db2-9066-d451c897c88e)
          
          - `CloudTrail_Area_사용자` (`type: horizontal_bar`): 사용자(`userIdentity.userName`)별 CloudTrail 이벤트 수의 시간 추세를 가로 막대 차트로 표시합니다.
          
          ![image](https://github.com/user-attachments/assets/717cfc08-94b1-479d-9a78-740759460feb)
          
          - `CloudTrail_Area_사용량` (`type: line`): AWS Region(`awsRegion`)별 CloudTrail 이벤트 수의 시간 추세를 라인 차트로 표시합니다. (참고: VisState에는 `line`으로 정의되어 있습니다.)
          
          ![image](https://github.com/user-attachments/assets/c78201d0-d689-4f03-9aff-f660260f6536)

          
          Discover 패널 목록:
          
          - `CloudTrail_Discover_CUD` (`type: search`): CloudTrail 로그 중에서 `Describe*`, `List*`, `Get*`, `AssumeRole` 등 조회성 이벤트를 제외한(즉, Create, Update, Delete 등 변경 이벤트를 포함하는) 로그들의 상세 내역을 테이블 형태로 보여줍니다. (`userIdentity.userName`, `eventName`, `sourceIPAddress`, `sourceDomain` 컬럼 등을 표시)
          
          ![image](https://github.com/user-attachments/assets/d5945f2d-929e-49e1-add4-6bd7dd15ac9f)

          
      2. RDS Metric Dashboard
          
          **Visualize 패널 목록:**
          
          - `RDS_Metric_Gauge_메모리사용량` (`type: gauge`): RDS `FreeableMemory` 메트릭의 평균값을 게이지 형태로 표시합니다.
          
          ![image](https://github.com/user-attachments/assets/289eb252-0acb-4d1d-9df9-42f831b4c635)

          
          - `RDS_Metric_Gauge_스토리지용량` (`type: gauge`): RDS `BinLogDiskUsage` 메트릭의 평균값을 게이지 형태로 표시합니다.
          
          ![image](https://github.com/user-attachments/assets/a4c14662-50c9-4904-8377-51b098cd5509)

          
          - `RDS_Metric_Line_IOPS` (`type: area`): RDS `ReadIOPS` 및 `WriteIOPS` 메트릭의 평균값 시간 추세를 라인 또는 영역 차트로 표시하며, `metric_name`과 `DBInstanceIdentifier`별로 그룹화합니다.
          
          ![image](https://github.com/user-attachments/assets/507dc5c2-b395-4497-8510-ed17beef3138)

          
          - `RDS_Metric_Metric_연결수` (`type: metric`): RDS `DatabaseConnections` 메트릭의 최대값을 단일 메트릭으로 표시하며, `DBInstanceIdentifier`별로 그룹화합니다.
          
          ![image](https://github.com/user-attachments/assets/85452cb1-03ff-4d4b-8245-1b6bee7833a5)

          
          - `RDS_Metric_Line_Throughput` (`type: line`): RDS `WriteThroughput`, `ReadThroughput`, `NetworkTransmitThroughput` 메트릭의 평균값 시간 추세를 라인 차트로 표시하며, `metric_name`별로 그룹화합니다.
          
          ![image](https://github.com/user-attachments/assets/b408bf85-2c1a-488a-86f6-fa7e041a36e5)

          
          - `RDS_Metric_Line_메모리사용량` (`type: line`): RDS `FreeableMemory` 메트릭의 평균값 시간 추세를 라인 차트로 표시하며, `DBInstanceIdentifier`별로 그룹화합니다.
          
          ![image](https://github.com/user-attachments/assets/d8f1d480-0890-4a05-8091-c6eeb46d80f9)

          
      
      3. Application Dashboard
      
      **Visualize 패널 목록:**
      
      - `EC2_Metric_Hitmap_CPUUtilization` (`type: heatmap`): `ec2-*` 인덱스에서 EC2 `CPUUtilization` 메트릭의 최대값을 시간과 `InstanceId`별로 그룹화하여 히트맵으로 표시합니다.
      
      ![image](https://github.com/user-attachments/assets/29c85230-b370-4cd6-92eb-bed331048c0c)

      
      - `Application_CoordinateMap_한국` (`type: tile_map`): `web-*` 인덱스에서 Application Access Log의 `geoip.location` (한국 내) 정보를 지도에 표시합니다.
      
      ![image](https://github.com/user-attachments/assets/a665b2fb-d3aa-47af-a2cf-5cab1d3ed33f)

      
      - `Application_TagCloud_스포츠선호도` (`type: tagcloud`): `web-*` 인덱스에서 Application Access Log의 `url.query_params.sport` 필드 값의 빈도를 태그 클라우드로 표시하여 인기 스포츠를 보여줍니다.
      
      ![image](https://github.com/user-attachments/assets/029e5349-cbe5-448f-9870-9b46b60ccd75)

      - `Application_CoordinateMap_세계지도` (`type: tile_map`): `web-*` 인덱스에서 Application Access Log의 `geoip.location` (전 세계) 정보를 지도에 표시합니다.
      
      ![image](https://github.com/user-attachments/assets/1eec6d82-ba52-41d7-b76c-fb80609beef7)
      
      - `Application_Pie_이벤트` (`type: pie`): `web-*` 인덱스에서 Application Access Log의 `eventName.keyword` 필드 값의 빈도를 파이 차트로 표시합니다.
      
      ![image](https://github.com/user-attachments/assets/a419ea79-b063-4b55-b967-13b53e2d4dac)

      - `EC2_Metric_Area_네트워크` (`type: line`): `ec2-*` 인덱스에서 EC2 `NetworkpacketsIn과 NetworkpacketOut` 메트릭의 평균값 시간 추세를 영역 차트로 표시하며, `InstanceId`별로 그룹화합니다.
      
      ![image](https://github.com/user-attachments/assets/c39a48a5-8190-4ae3-9e0a-2e343934f5a4)
      
      - `EC2_Metric_Line_EBS사용량` (`type: bar`): `ec2-*` 인덱스에서 EC2 `EBSWriteBytes` 및 `EBSReadBytes` 메트릭의 최대값 시간 추세를 Bar 차트로 표시하며, 필터 및 `InstanceId`별로 그룹화합니다.
      
      ![image](https://github.com/user-attachments/assets/0e7c9e78-662b-4126-8a5c-1d027c909471)
      
      **Discover 패널 목록:**
      
      - `Application_Discover_NotRouting` (`type: search`): `web-*` 인덱스에서 Application Access Log 중 `eventName`이 'PageRouting'이 아닌 로그들의 상세 내역을 테이블 형태로 보여줍니다.
    
      ![image](https://github.com/user-attachments/assets/7695ceec-2392-48fe-b822-9adb7c3f63a3)

